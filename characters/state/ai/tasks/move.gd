extends task

class_name move

export(move_state.move_mode) var move_mode: int = move_state.move_mode.RUNNING
export(Vector3) var direction: Vector3 = Vector3.FORWARD

func _run(delta: float) -> int:
	pawn.move_state.input_direction = direction
	return task_status.RUNNING
