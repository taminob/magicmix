extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."

var current_task: task = null

func _ready():
	if(state.is_player):
		return
	current_task = load(game.char_data[character.name]["behavior"]).instance() # todo: refactor, maybe init/save for ai component
	add_child(current_task)
	current_task.start(character)

func _process(delta: float):
	if(state.is_player || !current_task):
		return
	match current_task.run(delta):
		task.task_status.NEW:
			pass
		task.task_status.CANCEL:
			pass
		task.task_status.FAIL:
			current_task.reset()
			current_task.start(character)
		task.task_status.SUCCESS:
			print("task done: " + character.name)
		task.task_status.RUNNING:
			pass
