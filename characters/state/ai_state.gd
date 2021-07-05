extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."

var current_goal: goal

const STEPS_BEFORE_RECONSIDER = 500
var steps: int = 0

var characters_in_sight: Array = []
var characters_out_of_sight: Array = []
var objects_in_sight: Array = []
var objects_out_of_sight: Array = []

func _ready():
	if(state.is_player):
		return
	current_goal = goal.new()
	current_goal.init(character)

func reconsider():
	consider(null)
	for x in characters_in_sight:
		consider(x)
	for x in characters_out_of_sight:
		consider(x)
	for x in objects_in_sight:
		pass # todo: implement consider for objects
		#consider(x)
	for x in objects_out_of_sight:
		pass # todo: implement consider for objects
		#consider(x)
	characters_out_of_sight.clear()
	objects_out_of_sight.clear()

func consider(target: Node=null):
	current_goal = current_goal.next_goal(target)
	steps = 0

func _process(delta: float):
	if(state.is_player):
		return
	if(current_goal.work_towards(delta)):
		consider()
	steps += 1
	if(steps >= STEPS_BEFORE_RECONSIDER):
		reconsider()

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
	consider(body)

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	if(characters_in_sight.has(body)):
		characters_in_sight.erase(body)
		characters_out_of_sight.push_back(body)
	elif(objects_in_sight.has(body)):
		objects_in_sight.erase(body)
		objects_out_of_sight.push_back(body)
	reconsider()
