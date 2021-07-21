extends task

# run all children in sequence and fail as soon as one child fails
class_name sequence

var current_child_index: int

func init():
	.init()
	current_child_index = 0
	errors.debug_assert(get_child_count() > 0, "behavior selector requires children")
	init_children()

func _run(delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	var current_child: task = get_child(current_child_index)
	var current_status: int = current_child._run(delta)
	match current_status:
		task_status.FAIL:
			return task_status.FAIL
		task_status.SUCCESS:
			current_child_index += 1
	if(current_child_index < get_child_count()):
		return task_status.RUNNING
	else:
		return task_status.SUCCESS
