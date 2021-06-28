extends task

# run all children in sequence and succeed as soon as first child succeeds
class_name selector

var current_child_index: int

func init():
	current_child_index = 0
	init_children()

func _run(delta: float) -> int:
	var current_child: task = get_child(current_child_index)
	current_child._run(delta)
	match current_child.status:
		task_status.FAIL:
			current_child_index += 1
		task_status.SUCCESS:
			return task_status.SUCCESS
	if(current_child_index < get_child_count()):
		return task_status.RUNNING
	else:
		return task_status.FAIL
