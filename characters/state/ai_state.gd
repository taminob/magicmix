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

const STEPS_BEFORE_RECONSIDER_DURING_PLAN = 1000
const STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN = 30
var _steps_since_consider: int = 0

var brain: ai_mind
var should_reconsider: bool = false

func _ready():
	if(state.is_player):
		return
	_steps_since_consider = 0

func _process(_delta: float):
	if(state.is_player || (stats.dead && !stats.undead)):
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
		_steps_since_consider = 0
		should_reconsider = false

func get_current_knowledge() -> planner.knowledge:
	var know = planner.knowledge.new(stats.pain, stats.focus)
	know.enemy_in_sight = !brain.enemies_in_sight.empty()
	know.enemy_in_near = !brain.enemies_in_sight.empty() || !brain.enemies_out_of_sight.empty()
	know.ally_in_sight = !brain.allies_in_sight.empty()
	know.ally_in_near = !brain.allies_in_sight.empty() || !brain.allies_out_of_sight.empty()
	var most_damaged = brain.get_most_damaged_enemy()
	know.enemy_damaged = most_damaged && most_damaged.stats.pain_percentage() > 0.85
	most_damaged = brain.get_most_damaged_ally()
	know.ally_damaged = most_damaged && most_damaged.stats.pain_percentage() > 0.7
	know.talking = dialogue.is_dialogue_active()
	return know

func get_current_goals() -> Array:
	var survive_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain)
	survive_goal.requirements.pain = max(stats.pain - 10, 5) # todo? better requirements
	var fight_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_damaged)
	fight_goal.requirements.pain = stats.max_pain() * 0.9
	fight_goal.requirements.enemy_damaged = true
	var talk_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.talking)
	talk_goal.requirements.talking = true
	var patrol_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_in_sight)
	patrol_goal.requirements.pain = stats.max_pain() * 0.1
	patrol_goal.requirements.enemy_in_sight = true
	return [survive_goal, fight_goal, talk_goal, patrol_goal]

func get_idle_action() -> abstract_action:
	var idle_action: abstract_action
	match dialogue.job:
		"thief":
			#idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
			idle_action = load("res://characters/state/ai/actions/roam_action.gd").new()
		"guard":
			idle_action = load("res://characters/state/ai/actions/roam_action.gd").new()
		"mage":
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
		_:
			idle_action = load("res://characters/state/ai/actions/roam_action.gd").new()
			#idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
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
	machine.push_state(ai_machine.states.idle)

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	brain.out_of_sight(body)
	machine.push_state(ai_machine.states.idle)

func save(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	#_ai_state["mind"] = brain # todo: add save functionality for brain
	state_dict["ai"] = _ai_state

func init(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	brain = _ai_state.get("mind", ai_mind.new(pawn))
