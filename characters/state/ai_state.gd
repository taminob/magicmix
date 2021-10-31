extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var machine: Node = $"ai_machine"
# warning-ignore:unused_class_variable
onready var move: Node = $"../move"
# warning-ignore:unused_class_variable
onready var stats: Node = $"../stats"
# warning-ignore:unused_class_variable
onready var dialogue: Node = $"../dialogue"

const STEPS_BEFORE_RECONSIDER_DURING_PLAN = 100
const STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN = 30
var _steps_since_consider: int = 0

var brain: ai_mind
var should_reconsider: bool = false

func _ready():
	if(state.is_player):
		return
	_steps_since_consider = 0

func _process(_delta: float):
	if(state.is_player || (stats.dead && !stats.undead && !game.levels.current_level_death_realm)):
		return
	machine.process_state()
	if(_steps_since_consider == 0):
		brain.flush_out_of_sight()
	_steps_since_consider += 1
	if(machine.action_queue.empty() && _steps_since_consider >= STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN ||
		_steps_since_consider >= STEPS_BEFORE_RECONSIDER_DURING_PLAN):
		should_reconsider = true
	if(should_reconsider):
		machine.push_state(ai_machine.states.idle)
		brain.update_characters()
		_steps_since_consider = 0
		should_reconsider = false

func get_current_knowledge() -> planner.knowledge:
	var know = planner.knowledge.new(stats.pain, stats.focus, stats.stamina, stats.shield)
	know.flags[planner.flag.enemy_in_sight] = !brain.enemies_in_sight.empty()
	know.flags[planner.flag.enemy_in_near] = !brain.enemies_in_sight.empty() || !brain.enemies_out_of_sight.empty()
	know.flags[planner.flag.ally_in_sight] = !brain.allies_in_sight.empty()
	know.flags[planner.flag.ally_in_near] = !brain.allies_in_sight.empty() || !brain.allies_out_of_sight.empty()
	var most_damaged = brain.get_most_damaged_enemy()
	know.flags[planner.flag.enemy_damaged] = most_damaged && most_damaged.stats.pain_percentage() > 0.85
	most_damaged = brain.get_most_damaged_ally()
	know.flags[planner.flag.ally_damaged] = most_damaged && most_damaged.stats.pain_percentage() > 0.7
	know.flags[planner.flag.talking] = dialogue.is_dialogue_active()
	return know

func get_current_goals() -> Array:
#	var all_goals: Array = [survive_goal]
#	var current_goals: Array = []
#	for x in all_goals:
#		var score: float = x.score()
#		if(score > 0):
#			var i: int = 0
#			while i <= current_goals.size():
#				if(current_goals[i][1] < score || i == current_goals.size()):
#					current_goals.insert(i, [x, score])
#					break
#	for x in current_goals:
#		x = x[0]
#	return current_goals
	var goals: Array = []
	if(!stats.undead && !stats.dead):
		var survive_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain)
		survive_goal.requirements.values[planner.value.pain] = max(stats.pain - 10, 5) # todo? better requirements
		goals.push_back(survive_goal)
	var fight_goal: planner.goal
	if(stats.undead || stats.dead):
		fight_goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.enemy_damaged)
	else:
		fight_goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_damaged)
		fight_goal.requirements.values[planner.value.pain] = stats.max_pain() * 0.9
	fight_goal.requirements.flags[planner.flag.enemy_damaged] = true
	goals.push_back(fight_goal)
	var talk_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.talking)
	talk_goal.requirements.flags[planner.flag.talking] = true
	for x in dialogue.data.wants_to_talk_to:
		if(brain.is_in_sight_by_id(x)):
			goals.push_back(talk_goal)
			break
	if(dialogue.job == "guard"):
		var patrol_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_in_sight)
		patrol_goal.requirements.values[planner.value.pain] = stats.max_pain() * 0.1
		patrol_goal.requirements.flags[planner.flag.enemy_in_sight] = true
		goals.push_back(patrol_goal)
	return goals

func get_idle_action() -> abstract_action:
	var idle_action: abstract_action
	match dialogue.job:
		"thief":
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
		"guard":
			idle_action = load("res://characters/state/ai/actions/roam_action.gd").new()
		"mage":
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
		_:
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
	idle_action.init(pawn)
	return idle_action

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player || body == pawn || !body):
		return
	# todo: repeat cast after some time if fails (might be better in brain to check for everything "in sight" if it is actually visible
	var result: Dictionary = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), body.global_transform.origin)
	if(!result || result["collider"] != body):
		if(body is character):
			result = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), body.global_body_head())
			if(!result || result["collider"] != body):
				return
		else:
			return
	brain.in_sight(body)
	should_reconsider = true

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	brain.out_of_sight(body)
	should_reconsider = true

func save(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	#_ai_state["mind"] = brain # todo: add save functionality for brain
	state_dict["ai"] = _ai_state

func init(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	brain = _ai_state.get("mind", ai_mind.new(pawn))
