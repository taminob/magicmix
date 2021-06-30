extends move_to

class_name follow

# path relativ to level
export(String) var target_path: String
var target

func init():
	target = game.levels.current_level.get_node(target_path)
	assert(target, "target of follow behavior does not exist")
	location = target.translation
	.init()

func _run(delta: float) -> int:
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	location = target.translation
	var status = ._run(delta)
	if(status == task_status.SUCCESS):
		.init()
		return task_status.RUNNING
	return status
