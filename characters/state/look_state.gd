extends Node

class_name look_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"

var _default_mesh_path: String
var mesh: abstract_mesh = null
var color: Color
var animations: AnimationPlayer

func animations_process(_delta: float):
	if(state.is_spirit):
		return
	if(move.is_moving()):
		animations.play("walk")
	else:
		animations.play("idle")

func update_look(): # todo?
	mesh.default_primary_color = color
	mesh.reset()
	mesh.set_undead(stats.undead)
	mesh.set_frozen(move.frozen)

func size() -> Vector2:
	return mesh.get_size()

func _set_mesh(path: String=_default_mesh_path):
	if(mesh):
		mesh.queue_free()
	mesh = load(path).instance()
	pawn.add_child(mesh)
	animations = mesh.get_node("animations")

func _update_collision():
	var body_size: Vector2 = mesh.get_size()
	pawn.collision.shape = CapsuleShape.new()
	pawn.collision.shape.radius = body_size.x / 2
	# todo? rotate collision if width > height
	pawn.collision.shape.height = body_size.y - body_size.x
	pawn.collision.translation.y = body_size.y / 2

func save(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	#_look_state["mesh_path"] = _mesh_path # todo? save new mesh?
	state_dict["look"] = _look_state

func init(state_dict: Dictionary):
	var _look_state = state_dict.get("look", {})
	_default_mesh_path = _look_state.get("mesh_path", "res://characters/meshes/debug/body.tscn")
	_set_mesh()
	color = _look_state.get("color", Color(0, 0, 0))
	update_look()
	_update_collision()
