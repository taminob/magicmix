extends Node

# TODO: DEBUG, remove
var debug_levels: Dictionary = {
	"palace_entry": {
		"path": "res://world/levels/palace_entry/level.tscn",
	},
	"house_inside": {
		"path": "res://world/levels/town/house_inside.tscn",
	},
	"debug": {
		"path": "res://world/levels/debug/level.tscn",
	},
	"debug1": {
		"path": "res://world/levels/debug1/level.tscn",
	},
	"debug_death1": {
		"path": "res://world/levels/debug_death1/level.tscn",
		"death_realm": true
	},
	"debug2": {
		"path": "res://world/levels/debug2/level.tscn",
	},
	"debug3": {
		"path": "res://world/levels/debug3/level.tscn",
	},
	"debug3_outside": {
		"path": "res://world/levels/intro_outside/level.tscn",
	},
	"debug_ai": {
		"path": "res://world/levels/debug_ai/level.tscn",
	},
}
func from_dict(dict: Dictionary) -> abstract_level:
	var new_level = abstract_level.new()
	new_level.data["level_data"] = dict
	return new_level


func _ready():
	# TODO: move to static array?
	var dir: Directory = Directory.new()
	errors.debug_assert(dir.open("res://scripts/game/levels/") == OK, "unable to find levels directory")
	dir.list_dir_begin(true, true)
	while true:
		var file: String = dir.get_next()
		if(file.empty()):
			break
		var level = load(dir.get_current_dir() + file)
		level_data[level.id()] = level.new()

	for x in debug_levels.keys():
		level_data[x] = from_dict(debug_levels[x])

var level_data: Dictionary = {}

var current_level_id: String = ""
var current_level: Node = null
var current_level_death_realm: bool = false

func change_level(level_id: String):
	game.mgmt.save_characters()
	loader.load_resource(level_data[level_id].scene_path(), funcref(self, "_load_callback"), true)
	current_level_id = level_id
	current_level_death_realm = level_data[level_id].is_in_death_realm()

func _load_callback(new_level: Resource):
	var world = scenes.game_instance.get_node("world_container/viewport/world")
	if(current_level):
		current_level.name = "_level"
		game.mgmt.unmake_player()
		world.call_deferred("remove_child", current_level)
		current_level.call_deferred("free")
	current_level = new_level.instance()
	current_level.name = "level"
	var new_player = current_level.get_node_or_null(game.mgmt.player_name)
	if(new_player):
		game.mgmt.call_deferred("make_player", new_player)
	else:
		game.mgmt.create_player()
		var spawn = current_level.get_node_or_null("player_spawn")
		if(spawn):
			game.mgmt.player.translation = spawn.translation
		current_level.call_deferred("add_child", game.mgmt.player)
	game.mgmt.camera.call_deferred("update_environment")
	errors.log("change level: " + current_level_id)
	world.call_deferred("add_child", current_level)
	game.mgmt.ui.reset()
