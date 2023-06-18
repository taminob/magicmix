extends Node3D

@onready var lid: Node3D = $"lid"

var is_open: bool = false
var _closed_transform: Transform3D
var _opened_transform: Transform3D

func _ready():
	_closed_transform = lid.transform
	_opened_transform = lid.transform
	_opened_transform = _opened_transform.rotated(Vector3(1, 0, 0), deg_to_rad(30)).translated(Vector3(-0.3, 0.4, 0))

func get_interaction() -> String:
	return "Close" if is_open else "Open"

func interact(interactor: character):
	if(is_open):
		close_box()
	else:
		open_box(interactor)

func open_box(interactor: character):
	lid.transform = _opened_transform
	is_open = true
	var item_list = game.levels.current_level_data.get_box_content(name)
	if(item_list.is_empty()):
		return
	interactor.inventory.things.append_array(item_list)
	game.levels.current_level_data.set_box_content(name, [])

func close_box():
	lid.transform = _closed_transform
	is_open = false
