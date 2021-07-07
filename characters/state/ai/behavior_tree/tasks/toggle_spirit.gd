extends task

class_name toggle_spirit_task

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	pawn.interaction.toggle_spirit()
	return task_status.SUCCESS
