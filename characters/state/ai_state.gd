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

const STEPS_BEFORE_RECONSIDER_DURING_PLAN = 100000
const STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN = 30
var _steps_since_consider: int = 0

var brain: ai_mind
var behavior: abstract_behavior
var should_reconsider: bool = false

func _ready():
	if(state.is_player):
		return
	_steps_since_consider = 0

func _process(delta: float):
	if(state.is_player || (stats.dead && !stats.undead && !game.levels.current_level_death_realm)):
		return
	brain.process_mind(delta)
	machine.process_state(delta)
	_steps_since_consider += 1
	if(machine.action_queue.empty() && _steps_since_consider >= STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN ||
		_steps_since_consider >= STEPS_BEFORE_RECONSIDER_DURING_PLAN):
		should_reconsider = true
	if(should_reconsider):
		machine.push_state(ai_machine.states.idle)
		_steps_since_consider = 0
		should_reconsider = false

func get_current_knowledge() -> planner.knowledge:
	var know = planner.knowledge.new(stats.pain, stats.focus, stats.stamina, stats.shield)
	know.flags[planner.flag.enemy_in_sight] = brain.is_any_in_sight(ai_mind.body_type.enemy)
	know.flags[planner.flag.enemy_in_near] = brain.is_any_in_sight(ai_mind.body_type.enemy) || brain.is_any_out_of_sight(ai_mind.body_type.enemy)
	know.flags[planner.flag.ally_in_sight] = brain.is_any_in_sight(ai_mind.body_type.ally)
	know.flags[planner.flag.ally_in_near] = brain.is_any_in_sight(ai_mind.body_type.ally) || brain.is_any_out_of_sight(ai_mind.body_type.ally)
	var most_damaged = brain.get_most_damaged(ai_mind.body_type.enemy)
	know.flags[planner.flag.enemy_damaged] = most_damaged && most_damaged.stats.pain_percentage() > 0.85
	most_damaged = brain.get_most_damaged(ai_mind.body_type.ally)
	know.flags[planner.flag.ally_damaged] = most_damaged && most_damaged.stats.pain_percentage() > 0.7
	know.flags[planner.flag.talking] = dialogue.is_dialogue_active()
	return know

func get_current_goals() -> Array:
	return behavior.goals(pawn)

func get_current_actions() -> Array:
	return behavior.actions(pawn)

func get_idle_action() -> abstract_action:
	return behavior.idle_action(pawn)

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player || body == pawn || !body):
		return
	brain.register_in_cone(body)

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	brain.unregister_in_cone(body)

func save(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	#_ai_state["mind"] = brain # todo: add save functionality for brain
	# todo? save behavior for self modifying behaviors?
	state_dict["ai"] = _ai_state

func init(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	brain = _ai_state.get("mind", ai_mind.new(pawn))
	if(ResourceLoader.exists("res://characters/persons/behaviors/" + pawn.name + ".gd")):
		behavior = load("res://characters/persons/behaviors/" + pawn.name + ".gd").new()
	else:
		behavior = load("res://characters/persons/behaviors/behavior.gd").new()
