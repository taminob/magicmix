extends task

class_name turn

export var turn_degrees: float = 0.0

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	pawn.rotate(Vector3.UP, deg2rad(turn_degrees))
	return task_status.SUCCESS
