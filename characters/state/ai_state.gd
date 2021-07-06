extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."
onready var machine: Node = $"ai_machine"
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"

const STEPS_BEFORE_RECONSIDER = 500
var steps_since_consider: int = 0

var characters_in_sight: Array = []
var characters_out_of_sight: Array = []
var objects_in_sight: Array = []
var objects_out_of_sight: Array = []

func _ready():
	if(state.is_player):
		return
	steps_since_consider = 0

func _process(delta: float):
	if(state.is_player):
		return
	machine.process_state()
	steps_since_consider += 1
	if(steps_since_consider >= STEPS_BEFORE_RECONSIDER):
		machine.push_state(ai_machine.states.idle)

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player || body == character || !body):
		return
	if(body as character):
		if(characters_out_of_sight.has(body)):
			characters_out_of_sight.erase(body)
		characters_in_sight.push_back(body)
	elif(body.has_method("interact")):
		if(objects_out_of_sight.has(body)):
			objects_out_of_sight.erase(body)
		objects_in_sight.push_back(body)
	machine.push_state(ai_machine.states.idle)

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	if(characters_in_sight.has(body)):
		characters_in_sight.erase(body)
		characters_out_of_sight.push_back(body)
	elif(objects_in_sight.has(body)):
		objects_in_sight.erase(body)
		objects_out_of_sight.push_back(body)
	machine.push_state(ai_machine.states.idle)
