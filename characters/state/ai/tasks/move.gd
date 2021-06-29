extends task

class_name move

export(move_state.move_mode) var move_mode: int = move_state.move_mode.RUNNING
export(Vector3) var direction: Vector3 = Vector3.FORWARD

func _run(_delta: float) -> int:
	pawn.move.current_mode = move_mode
	pawn.move.input_direction = direction
	return task_status.SUCCESS
