extends Node

# TODO: DEBUG, remove
var debug_levels: Dictionary = {
	"palace_entry": {
		"path": "res://world/levels/palace_entry/level.tscn",
		"boxes": {
			"box1": ["fire_token"],
		},
	},
	"house_inside": {
		"path": "res://world/levels/town/house_inside.tscn",
	},
	"debug": {
		"path": "res://world/levels/debug/level.tscn",
	},
	"debug1": {
		"path": "res://world/levels/debug1/level.tscn",
		"boxes": {
			"box1": ["deadly_poison", "deadly_poison", "dark_potion", "fire_token"],
			"box2": ["deadly_poison", "dark_potion", "deadly_poison", "dark_potion", "deadly_poison"]
		},
	},
	"debug_death1": {
		"path": "res://world/levels/debug_death1/level.tscn",
		"boxes": {
			"box1": ["dark_token", "deadly_poison"]
		},
		"death_realm": true
	},
	"debug2": {
		"path": "res://world/levels/debug2/level.tscn",
	},
	"debug3": {
		"path": "res://world/levels/debug3/level.tscn",
		"boxes": {
			"box1": ["deadly_poison", "deadly_poison"],
		},
	},
	"debug3_outside": {
		"path": "res://world/levels/intro_outside/level.tscn",
	},
	"debug_ai": {
		"path": "res://world/levels/debug_ai/level.tscn",
	},
}
func from_dict(dict: Dictionary) -> Object:
	var new_level = load("res://scripts/game/levels/debug_level.gd").new()
	new_level.data["debug_level_data"] = dict
	if(dict.has("boxes")):
		new_level.data["boxes"] = dict["boxes"]
	return new_level

func _ready():
	# TODO: move to static array?
	var dir: Directory = Directory.new()
	errors.debug_assert(dir.open("res://scripts/game/levels/") == OK, "unable to find levels directory")
	errors.error_test(dir.list_dir_begin(true, true))
	while true:
		var file: String = dir.get_next()
		if(file.empty()):
			break
		if(file == "debug_level.gd"):
			continue
		var level = load(dir.get_current_dir() + file)
		level_data[level.id()] = level.new()
	dir.list_dir_end()

	for x in debug_levels.keys():
		level_data[x] = from_dict(debug_levels[x])

var level_data: Dictionary = {}

var current_level_data: abstract_level
var current_level: Node = null

func change_level(level_id: String):
	game.mgmt.save_characters()
	current_level_data = level_data[level_id]
	loader.load_resource(current_level_data.scene_path(), funcref(self, "_load_callback"), true)

func _load_callback(new_level: Resource):
	var world = scenes.game_instance.get_node("world_container/viewport/world")
	if(current_level):
		current_level.name = "_level"
		game.mgmt.unmake_player()
		world.call_deferred("remove_child", current_level)
		current_level.call_deferred("free")
	current_level = new_level.instance()
	current_level.name = "level"
	var new_player = current_level.get_node_or_null(game.mgmt.player_id)
	if(new_player):
		game.mgmt.call_deferred("make_player", new_player)
	else:
		game.mgmt.create_player()
		var spawn = current_level.get_node_or_null("player_spawn")
		if(spawn):
			game.mgmt.player.translation = spawn.translation
		current_level.call_deferred("add_child", game.mgmt.player)
	game.mgmt.camera.call_deferred("update_environment")
	errors.log("change level: " + current_level_data.id())
	world.call_deferred("add_child", current_level)
	game.mgmt.ui.reset()
