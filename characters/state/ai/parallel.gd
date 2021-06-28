extends task

# run all children parallel and fail as soon as one child fails
class_name parallel

var current_tasks: Array

func init():
	current_tasks = get_children()
	init_children()

func _run(delta: float) -> int:
	var i: int = 0
	while i < current_tasks.size():
		var current_status = current_tasks[i]._run(delta)
		match current_status:
			task_status.FAIL:
				return task_status.FAIL
			task_status.SUCCESS:
				current_tasks.remove(i)
		i += 1
	if(current_tasks.empty()):
		return task_status.SUCCESS
	return task_status.RUNNING
