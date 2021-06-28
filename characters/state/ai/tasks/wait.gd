extends task

class_name wait

export var wait_time: float = 0

var _wait_counter: float

func init():
	_wait_counter = wait_time

func _run(delta: float) -> int:
	_wait_counter -= delta
	if(_wait_counter < 0):
		return task_status.SUCCESS
	return task_status.RUNNING
