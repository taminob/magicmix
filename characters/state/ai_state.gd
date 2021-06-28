extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."

#var _time_counter: float = -1
var current_task: task = null

func _ready():
	if(state.is_player):
		return
	current_task = load("res://characters/behavior/patrol.tscn").instance()
	add_child(current_task)
	current_task.start(character)
#	move.input_direction = Vector3.FORWARD

func _process(delta: float):
	if(state.is_player || !current_task):
		return
	match current_task.run(delta):
		task.task_status.NEW:
			pass
		task.task_status.CANCEL:
			pass
		task.task_status.RUNNING:
			pass
		task.task_status.FAIL:
			pass
		task.task_status.SUCCESS:
			pass
#	_time_counter -= delta
#	if(_time_counter <= 0):
#		_on_timeout()
#		_time_counter = 2
#
#func _on_timeout():
#	character.rotate_y(deg2rad(180))
