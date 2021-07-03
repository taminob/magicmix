extends task

class_name cancel_task

export(NodePath) var task_path: NodePath
var task_to_cancel: task

func init():
	.init()
	task_to_cancel = get_node_or_null(task_path)
	assert(task_to_cancel, "in behavior cancel_task no or invalid task assigned")

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	task_to_cancel.cancel()
	return task_status.SUCCESS
