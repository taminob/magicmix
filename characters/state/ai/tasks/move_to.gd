extends task

class_name move_to

export var location: Vector3 = Vector3.ZERO
export(move_state.move_mode) var move_mode: int = move_state.move_mode.RUNNING

func _run(delta: float) -> int:
	if(pawn.translation.is_equal_approx(location)):
		return task_status.SUCCESS
	else:
		return task_status.RUNNING
