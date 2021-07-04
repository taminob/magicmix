extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."

var current_goal: goal

const STEPS_BEFORE_RECONSIDER = 500
var steps: int = 0

var characters_in_sight: Array = []

func _ready():
	if(state.is_player):
		return
	current_goal = goal.new()
	current_goal.init(character)

func reconsider():
	consider(null)
	for x in characters_in_sight:
		consider(x)

func consider(target:character=null):
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
	if(state.is_player):
		return
	if(body as character && body != character):
		characters_in_sight.push_back(body)
		consider(body)

func _on_sight_zone_body_exited(body: Node):
	if(body && characters_in_sight.has(body)):
		 # todo: might cause problems with loops using characters_in_sight
		game.mgmt.call_delayed(characters_in_sight, "erase", 10, [body])
		#characters_in_sight.erase(body)
		consider()
