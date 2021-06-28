extends task

class_name turn

export var turn_degrees: float = 0.0

func _run(_delta: float) -> int:
	pawn.rotate_y(deg2rad(turn_degrees))
	return task_status.SUCCESS
