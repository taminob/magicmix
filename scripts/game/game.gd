extends Node

const game_script_path = "res://scripts/game/"

#var spells
#var items
var chars: Node
var char_data: Dictionary
var levels: Node
var mgmt: Node
var world: Node

func _ready():
	reload_game()

func reload_game():
#	spells = load(game_script_path + "spells.gd").new().spells
#	items = load(game_script_path + "items.gd").new().items
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
	char_data = chars.characters
	mgmt = load(game_script_path + "management.gd").new()
	add_child(mgmt)
	world = load(game_script_path + "world.gd").new()
	add_child(world)
	levels = load(game_script_path + "levels.gd").new()
	add_child(levels)

func get_character(id) -> Dictionary:
	return char_data.get(id, {})
