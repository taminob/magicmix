extends Node

const game_script_path = "res://scripts/game/"

var chars: Node
var char_data: Dictionary
var levels: Node
var mgmt: Node
var world: Node

func _ready():
	reload_game()

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
	char_data = chars.characters
	mgmt = load(game_script_path + "management.gd").new()
	add_child(mgmt)
	world = load(game_script_path + "world.gd").new()
	add_child(world)
	levels = load(game_script_path + "levels.gd").new()
	add_child(levels)

var _loading_scene: Control = null
var _loading_callback: FuncRef
func load_resource(path: String, callback: FuncRef):
	_loading_scene = preload("res://menu/loading/loading.tscn").instance()
	scenes.open_scene(_loading_scene)
	_loading_scene.track_loader(ResourceLoader.load_interactive(path))
	_loading_callback = callback
	get_tree().paused = true

func finished_loading(loader: ResourceInteractiveLoader):
	get_tree().paused = false
	scenes.close_scene()
	_loading_callback.call_func(loader.get_resource())

func get_character(id) -> Dictionary:
	return char_data.get(id, {})
