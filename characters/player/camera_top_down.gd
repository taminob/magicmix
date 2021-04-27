extends Spatial

onready var camera = $"spring_arm/player_camera"
onready var ray_cast = $"spring_arm/player_camera/ray_cast"

# todo: needs rework
var last_obstructing_objects = []
func _physics_process(delta):
	var obstructing_objects = []
	var space_state = get_world().get_direct_space_state()
	while true:
		var collision_result = space_state.intersect_ray(camera.get_global_transform().origin, management.player.get_global_transform().origin, obstructing_objects)
		if(collision_result.has("collider") && !management.is_player(collision_result.collider) && collision_result.collider != camera):
			obstructing_objects.push_back(collision_result.collider)
		else:
			break
	# todo: set alpha to ~0.5 instead of completely hidden
	for x in last_obstructing_objects:
		if(x is StaticBody):
			x.get_parent().set_visible(true)
		else:
			x.set_visible(true)
	for x in obstructing_objects:
		if(x is StaticBody):
			x.get_parent().set_visible(false)
		else:
			x.set_visible(false)
	last_obstructing_objects = obstructing_objects
