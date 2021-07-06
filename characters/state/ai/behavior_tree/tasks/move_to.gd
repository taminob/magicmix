extends move

class_name move_to

export var location: Vector3 = Vector3.ZERO
export var radius: float = 1

func _run(delta: float) -> int:
	# todo: find better abstraction for move
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	# todo: use nav mesh; alternative for side walking: pawn.move.input_direction = pawn.translation.direction_to(location)
	if(pawn.state.is_spirit):
		pawn.spirit.look_at(location, pawn.spirit.transform.basis.y)
	else:
		pawn.look_at(Vector3(location.x, pawn.translation.y, location.z), Vector3.UP)

	direction = Vector3.FORWARD
# warning-ignore:return_value_discarded
	._run(delta)
	if(pawn.translation.distance_squared_to(location) <= radius * radius):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.SUCCESS
	else:
		return task_status.RUNNING
