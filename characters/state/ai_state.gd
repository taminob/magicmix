extends Node

class_name ai_state

@onready var state: Node = get_parent()
@onready var pawn: CharacterBody3D = $"../.."
@onready var machine: Node = $"ai_machine"
# warning-ignore:unused_class_variable
@onready var move: Node = $"../move"
# warning-ignore:unused_class_variable
@onready var stats: Node = $"../stats"
# warning-ignore:unused_class_variable
@onready var dialogue: Node = $"../dialogue"

const STEPS_BEFORE_RECONSIDER_DURING_PLAN = 500
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
	if(state.is_player || (stats.dead && !stats.undead && !game.levels.current_level_data.is_in_death_realm()) || move.frozen):
		return
	brain.process_mind(delta)
	machine.process_state(delta)
	_steps_since_consider += 1
	if(machine.action_queue.is_empty() && _steps_since_consider >= STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN ||
		_steps_since_consider >= STEPS_BEFORE_RECONSIDER_DURING_PLAN):
		should_reconsider = true
	if(should_reconsider):
		machine.push_state(ai_machine.states.idle)
		_steps_since_consider = 0
		should_reconsider = false

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
	if(ResourceLoader.exists("res://characters/behaviors/" + pawn.name + ".gd")):
		behavior = load("res://characters/behaviors/" + pawn.name + ".gd").new()
	else:
		behavior = load("res://characters/behaviors/behavior.gd").new()
