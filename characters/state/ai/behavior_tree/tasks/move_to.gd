extends move_task

class_name move_to_task

export var global_location: Vector3 = Vector3.ZERO
export var radius: float = 1

func _run(delta: float) -> int:
	# todo: find better abstraction for move
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	# todo: use nav mesh; alternative for side walking: pawn.move.input_direction = pawn.translation.direction_to(location)
	if(pawn.state.is_spirit):
		pawn.spirit.look_at(global_location, pawn.spirit.transform.basis.y)
	else:
		pawn.face_location(global_location)

	direction = Vector3.FORWARD
# warning-ignore:return_value_discarded
	._run(delta)
	if(pawn.global_transform.origin.distance_squared_to(global_location) <= radius * radius):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.SUCCESS
	else:
		return task_status.RUNNING
