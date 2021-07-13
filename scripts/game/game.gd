extends Node

const game_script_path = "res://scripts/game/"

var chars: Node
var char_data: Dictionary
var levels: Node
var mgmt: Node
var world: Node

func reload_game():
	if(chars):
		remove_child(chars)
	if(mgmt):
		remove_child(mgmt)
	if(levels):
		remove_child(levels)
	if(world):
		remove_child(world)
	chars = load(game_script_path + "characters.gd").new()
	add_child(chars)
	char_data = chars.character_data
	mgmt = load(game_script_path + "management.gd").new()
	add_child(mgmt)
	world = load(game_script_path + "world.gd").new()
	add_child(world)
	levels = load(game_script_path + "levels.gd").new()
	add_child(levels)

func get_character(id) -> Dictionary:
	return char_data.get(id, {})
