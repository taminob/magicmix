extends Node

const game_script_path = "res://scripts/game/"

var _char_data_node: Node
var char_data: Dictionary
var levels: Node
var mgmt: Node
var world: Node

func reload_game():
	if(_char_data_node):
		remove_child(_char_data_node)
	if(mgmt):
		remove_child(mgmt)
	if(levels):
		remove_child(levels)
	if(world):
		remove_child(world)
	_char_data_node = load(game_script_path + "character_data.gd").new()
	add_child(_char_data_node)
	char_data = _char_data_node.character_data
	mgmt = load(game_script_path + "management.gd").new()
	add_child(mgmt)
	world = load(game_script_path + "world.gd").new()
	add_child(world)
	levels = load(game_script_path + "levels.gd").new()
	add_child(levels)

func get_character(id: String) -> Dictionary:
	if(id.find("minion") >= 0):
		id = ""
	errors.debug_assert(char_data.has(id), "trying to access character data for " + id + " who does not exist!")
	return char_data.get(id, {})

func is_valid(object: Node):
	return object && !object.is_queued_for_deletion()
