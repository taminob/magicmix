extends Spatial

onready var lid: Spatial = $"lid"

var is_open: bool = false
var _closed_transform: Transform
var _opened_transform: Transform

func _ready():
	_closed_transform = lid.transform
	_opened_transform = lid.transform
	_opened_transform = _opened_transform.rotated(Vector3(1, 0, 0), deg2rad(30)).translated(Vector3(-0.3, 0.4, 0))
	assert(game.world.boxes[game.levels.current_level_name].has(name), "content of box not defined")

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
	var item_list = game.world.boxes[game.levels.current_level_name].get(name, [])
	if(item_list.empty()):
		return
	interactor.inventory.things.append_array(item_list)
	item_list.clear()

func close_box():
	lid.transform = _closed_transform
	is_open = false
