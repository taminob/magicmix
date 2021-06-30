extends move

class_name move_to

export var location: Vector3 = Vector3.ZERO
#export(move_state.move_mode) var move_mode: int = move_state.move_mode.RUNNING

func _run(delta: float) -> int:
	# todo: find better abstraction for move
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	# todo: use nav mesh
	#pawn.move.input_direction = pawn.translation.direction_to(location)
	direction = pawn.translation.direction_to(location)
# warning-ignore:return_value_discarded
	._run(delta)
	if(pawn.translation.is_equal_approx(location)):
		return task_status.SUCCESS
	else:
		return task_status.RUNNING
