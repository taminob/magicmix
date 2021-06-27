extends Node

class_name look_state

onready var character: KinematicBody = $"../.."
onready var move: Node = $"../move"

var _mesh_path: String
var mesh: Spatial = null
var animations: AnimationPlayer

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

func set_mesh(path:String=_mesh_path):
	if(mesh):
		mesh.queue_free()
	mesh = load(path).instance()
	character.add_child(mesh)
	animations = mesh.get_node("animations")

func save(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	#_look_state["mesh"] = _mesh_path
	state_dict["look"] = _look_state

func init(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	_mesh_path = _look_state.get("mesh", "res://characters/meshes/debug/body.tscn")
	set_mesh()
