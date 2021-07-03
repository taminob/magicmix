extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."
onready var skills: Node = $"../skills"
onready var stats: Node = $"../stats"
onready var dialogue: Node = $"../dialogue"

var current_goal: goal

var characters_in_sight: Array = []

func _ready():
	if(state.is_player):
		return
	current_goal = goal.new()
	current_goal.init(character)

func _process(delta: float):
	if(state.is_player):
		return
	if(current_goal.work_towards(delta)):
		current_goal = current_goal.next_goal()

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player):
		return
	if(body as character && body != character):
		characters_in_sight.push_back(body)
		current_goal = current_goal.next_goal(body)

func _on_sight_zone_body_exited(body: Node):
	if(characters_in_sight.has(body)):
		characters_in_sight.erase(body)
		current_goal = current_goal.next_goal()
