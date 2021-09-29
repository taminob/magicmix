extends Node

class_name look_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"

var _default_mesh_path: String
var mesh: Spatial = null
var clothing: SoftBody = null
var animations: AnimationPlayer
var body_height: float

func animations_process(_delta: float):
	if(move.is_moving()):
		animations.play("walk")
	else:
		animations.play("idle")

func update_look(): # todo?
	if(mesh):
		var material = mesh.get("material")
		if(material):
			material = material.duplicate()
			material.set("albedo_color", Color(0.9, 0.9, 0.2))
			mesh.material_override = material

func set_mesh(path: String=_default_mesh_path):
	if(mesh):
		mesh.queue_free()
	mesh = load(path).instance()
	#mesh.rotate_y(PI) # todo: fix meshes
	pawn.add_child(mesh)
	animations = mesh.get_node("animations")
	if(!clothing):
		spawn_cloth()

func spawn_cloth():
	pass
#	clothing = SoftBody.new()
#	clothing.collision_layer = game.mgmt.layer.objects
#	clothing.collision_mask = game.mgmt.physical_layers
#	#clothing.parent_collision_ignore = pawn.get_path()
#	clothing.set_ray_pickable(false)
#	clothing.set_simulation_precision(100)
#	clothing.set_linear_stiffness(0.5)
#	clothing.set_areaAngular_stiffness(0.5)
#	clothing.set_volume_stiffness(0.5)
#	clothing.set_damping_coefficient(0.08)
#	clothing.set_total_mass(1)
#	#var cloth_mesh = PlaneMesh.new()
#	#cloth_mesh.set_size(Vector2(4, 4))
#	#cloth_mesh.set_subdivide_depth(16)
#	#cloth_mesh.set_subdivide_width(16)
#	var cloth_mesh = load("res://characters/meshes/shade_cloth_mesh.tres")
#	clothing.set_mesh(cloth_mesh)
#	#clothing.scale = Vector3(0.1, 0.1, 0.1)
#	var cloth_material = SpatialMaterial.new()
#	cloth_material.set_cull_mode(SpatialMaterial.CULL_DISABLED)
#	cloth_material.set_albedo(Color(1.0, 0.0, 0.0))
#	clothing.set_material_override(cloth_material)
#	pawn.add_child(clothing)
#	#clothing.translation = Vector3.UP * 2
#	#clothing.scale = Vector3(0.1, 0.1, 0.1)
#	#clothing.rotate_x(deg2rad(90))
#	#clothing.rotate_y(deg2rad(180))

func update_collision(new_height: float=body_height):
#	if(mesh && mesh.has_method("get_collision_shape")):
#		pawn.collision.shape = mesh.get_collision_shape()
#		pawn.collision.translation = Vector3.ZERO
#		pawn.collision.rotation_degrees = Vector3.ZERO
	if(mesh && mesh.has_method("get_collision_size")):
		var body_size: Vector2 = mesh.get_collision_size()
		pawn.collision.shape.radius = body_size.x / 2
		new_height = body_size.y
	# todo: rotate collision if width > height
	var width = pawn.collision.shape.radius * 2
	pawn.collision.shape.height = new_height - width
	pawn.collision.translation.y = new_height / 2

func set_color(color: Color):
	if(mesh && mesh.has_method("set_cape_color")):
		mesh.set_cape_color(color)
	if(mesh.has_method("set_material_override")):
		var mat: Material = SpatialMaterial.new()
		mat.set_albedo(color)
		mesh.set_material_override(mat)

func save(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	#_look_state["mesh_path"] = _mesh_path # todo? save new mesh?
	_look_state["height"] = body_height
	state_dict["look"] = _look_state

func init(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	_default_mesh_path = _look_state.get("mesh_path", "res://characters/meshes/debug/body.tscn")
	set_mesh()
	set_color(_look_state.get("color", Color(0, 0, 0)))
	body_height = _look_state.get("height", 1.8)
	update_collision()
