extends Node

var mgmt
var items
var characters
var levels
var spells

func _ready():
	load_game()

const game_script_path = "res://scripts/game/"
func load_game():
	spells = load(game_script_path + "spells.gd").new().spells
	items = load(game_script_path + "items.gd").new().items
	characters = load(game_script_path + "characters.gd").new()
	mgmt = load(game_script_path + "management.gd").new()
	levels = load(game_script_path + "levels.gd").new()
