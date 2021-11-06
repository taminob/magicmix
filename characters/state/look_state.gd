extends Node

class_name look_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"

var _default_mesh_path: String
var mesh: Spatial = null
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
	if(mesh):
		if(mesh.has_method("set_cape_color")):
			mesh.set_cape_color(color)
			if(mesh.has_method("set_character_color") && stats.undead):
				mesh.set_character_color(Color.black)
		elif(mesh.has_method("set_character_color")):
			mesh.set_character_color(color)
		elif(mesh.has_method("set_material_override")):
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
