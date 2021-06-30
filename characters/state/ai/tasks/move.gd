extends task

class_name move

export(move_state.move_mode) var move_mode: int = move_state.move_mode.RUNNING
export(Vector3) var direction: Vector3 = Vector3.FORWARD

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	pawn.move.current_mode = move_mode
	pawn.move.input_direction = direction
	return task_status.SUCCESS
