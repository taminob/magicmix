extends move_to_task

class_name follow_task

# path relativ to level
export(String) var target_path: String
export var follow_player: bool = false
var target

func init():
	if(follow_player):
		target = game.mgmt.player
	else:
		target = game.levels.current_level.get_node(target_path)
	errors.debug_assert(target != null, "target of follow behavior does not exist")
	global_location = target.global_transform.origin
	.init()

func _run(delta: float) -> int:
	if(_status == task_status.CANCEL):
		pawn.move.input_direction = Vector3.ZERO
		return task_status.CANCEL
	global_location = target.global_transform.origin
	var status = ._run(delta)
	if(status == task_status.SUCCESS):
		.init()
		return task_status.RUNNING
	return status
