extends task

class_name raycast_hit

# path relative to level
export(String) var target_path: String
var target

var _raycast: RayCast

func init():
	.init()
	target = game.levels.current_level.get_node(target_path)
	assert(target, "target of raycast_hit behavior does not exist")
	if(!_raycast):
		_raycast = RayCast.new()
		add_child(_raycast)
	_raycast.enabled = true
	_raycast.translation = pawn.translation
	_raycast.cast_to = _raycast.to_local(target.global_transform.origin)
	_raycast.add_exception(pawn)
	_raycast.collision_mask = game.mgmt.sight_layers

func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		_raycast.enabled = false
		return task_status.CANCEL
	var result = pawn.get_world().direct_space_state.intersect_ray(pawn.global_transform.origin, target.global_transform.origin)
	#_raycast.cast_to = _raycast.to_local(target.global_transform.origin)
	#_raycast.force_raycast_update()
	#var result = _raycast.get_collider()
	if(result):
		if(result["collider"] == target):
	#	if(result == target):
			_raycast.enabled = false
			return task_status.SUCCESS
		else:
			_raycast.enabled = false
			return task_status.FAIL
	return task_status.RUNNING
