extends move_to

class_name follow

# path relativ to level
export(String) var target_name: String
var target

func init():
	target = game.levels.current_level.get_node(target_name)
	assert(target, "target of follow behavior does not exist")
	location = target.translation
	.init()

func _run(delta: float) -> int:
	location = target.translation
	var status = ._run(delta)
	if(status == task_status.SUCCESS):
		.init()
		return task_status.RUNNING
	return status
