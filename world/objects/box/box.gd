extends Spatial

onready var lid: Spatial = $"lid"

var is_open: bool = false
var _closed_transform: Transform
var _opened_transform: Transform

func _ready():
	_closed_transform = lid.transform
	_opened_transform = lid.transform
	_opened_transform = _opened_transform.rotated(Vector3(1, 0, 0), deg2rad(30)).translated(Vector3(-0.3, 0.4, 0))

# warning-ignore:unused_class_variable
var interaction_name: String = "Open"
func interact(interactor: character):
	if(is_open):
		close_box()
	else:
		open_box(interactor)

func open_box(interactor: character):
	lid.transform = _opened_transform
	interaction_name = "Close"
	is_open = true
	var item_list = game.world.boxes[game.levels.current_level_name][name]
	if(item_list.empty()):
		return
	interactor.inventory.things.append_array(item_list)
	item_list.clear()

func close_box():
	lid.transform = _closed_transform
	interaction_name = "Open"
	is_open = false
