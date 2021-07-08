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

const STEPS_BEFORE_RECONSIDER = 500
var steps_since_consider: int = 0

var brain: ai_mind

func _ready():
	if(state.is_player):
		return
	steps_since_consider = 0

func _process(_delta: float):
	if(state.is_player):
		return
	machine.process_state()
	steps_since_consider += 1
	if(steps_since_consider >= STEPS_BEFORE_RECONSIDER):
		machine.push_state(ai_machine.states.idle)
		steps_since_consider = 0

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player || body == pawn || !body):
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
