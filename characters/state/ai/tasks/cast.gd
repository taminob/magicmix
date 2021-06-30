extends task

class_name cast

export(String) var spell: String

func _run(_delta: float) -> int:
	pawn.skills.cast(spell)
	return task_status.SUCCESS
