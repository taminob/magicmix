extends task

# remap returned status
class_name remap

export(task_status) var return_on_fail: int = task_status.SUCCESS
export(task_status) var return_on_success: int = task_status.FAIL
export(task_status) var return_while_running: int = task_status.RUNNING

func init():
	.init()
	assert(get_child_count() == 1, "behavior remap requires exactly one child")
	init_children()

func _run(delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	match get_child(0)._run(delta):
		task_status.SUCCESS:
			return return_on_success
		task_status.FAIL:
			return return_on_fail
		task_status.RUNNING:
			return return_while_running
		task_status.CANCEL:
			return task_status.CANCEL
		task_status.NEW:
			return task_status.NEW
	assert(false, "behavior remap does not check all possible return values")
	return task_status.RUNNING
