extends task

class_name cast_task

export(String) var spell: String

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	pawn.skills.cast(spell)
	return task_status.SUCCESS
