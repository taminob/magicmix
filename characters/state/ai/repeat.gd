extends task

# repeat first child, fail if child is not successful
class_name repeat

# repeat forever if negative
export var times: int = -1

var _times_counter: int

func init():
	_times_counter = times
	init_children()

func _run(delta: float) -> int:
	if(_times_counter == 0):
		return task_status.SUCCESS
	var current_status: int = get_child(0)._run(delta)
	if(current_status == task_status.SUCCESS):
		get_child(0).init()
		if(_times_counter > 0):
			_times_counter -= 1
	elif(current_status != task_status.RUNNING):
		return task_status.FAIL
	return task_status.RUNNING
