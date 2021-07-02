extends task

class_name raycast_hit

# path relative to level
export(String) var target_path: String
var target

func init():
	.init()
	target = game.levels.current_level.get_node(target_path)
	assert(target, "target of raycast_hit behavior does not exist")

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	var result = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_center(), target.global_body_center())
	if(result):
		if(result["collider"] == target):
			return task_status.SUCCESS
		else:
			return task_status.FAIL
	return task_status.RUNNING
