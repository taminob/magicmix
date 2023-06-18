extends Node3D

@export var is_open: bool = false

@onready var mesh: MeshInstance3D = $"door_mesh"

var _closed_transform: Transform3D
var _opened_transform: Transform3D

func _ready():
	_closed_transform = mesh.transform
	_opened_transform = mesh.transform
	_opened_transform = _opened_transform.translated(Vector3(2, 0, -2)).rotated(Vector3.UP, deg_to_rad(-70))
	if(is_open):
		open_door()

func get_interaction() -> String:
	return "Close" if is_open else "Open"

func interact(_interactor: character):
	toggle_open()

func toggle_open():
	if(is_open):
		close_door()
	else:
		open_door()

func open_door():
	mesh.transform = _opened_transform
	is_open = true

func close_door():
	mesh.transform = _closed_transform
	is_open = false
