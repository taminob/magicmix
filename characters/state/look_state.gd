extends Node

class_name look_state

onready var character: KinematicBody = $"../.."
onready var move: Node = $"../move"

var _default_mesh_path: String
var mesh: Spatial = null
var animations: AnimationPlayer
var body_height: float

func animations_process(_delta: float):
	if(move.input_direction.is_equal_approx(Vector3.ZERO)):
		animations.play("idle")
	else:
		animations.play("walk")

func update_look():
	if(mesh):
		var material = mesh.get("material")
		if material:
			material = material.duplicate()
			material.set("albedo_color", Color(0.9, 0.9, 0.2))
			mesh.material_override = material

func set_mesh(path:String=_default_mesh_path):
	if(mesh):
		mesh.queue_free()
	mesh = load(path).instance()
	mesh.rotate_y(PI) # todo: fix meshes
	character.add_child(mesh)
	animations = mesh.get_node("animations")

func set_height(new_height:float=body_height):
	# todo: rotate collision if width > height
	var width = character.collision.shape.radius * 2
	character.collision.shape.height = new_height - width
	character.collision.translation.y = new_height / 2

func save(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	#_look_state["mesh"] = _mesh_path
	_look_state["height"] = body_height
	state_dict["look"] = _look_state

func init(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	_default_mesh_path = _look_state.get("mesh", "res://characters/meshes/debug/body.tscn")
	set_mesh()
	body_height = _look_state.get("height", 1.8)
	set_height()
