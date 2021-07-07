extends task

class_name wait_task

export var wait_time: float = 0

var _wait_counter: float

func init():
	.init()
	_wait_counter = wait_time

func _run(delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	_wait_counter -= delta
	if(_wait_counter < 0):
		return task_status.SUCCESS
	return task_status.RUNNING
