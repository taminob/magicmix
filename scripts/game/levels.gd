extends Node

var levels = {
	"intro": {
		"path": "res://world/levels/intro/level.tscn",
		"death_realm": false
	},
	"palace": {
		"path": "res://world/levels/palace/level.tscn",
		"death_realm": false
	},
	"death_realm": {
		"path": "res://world/levels/death_realm/level.tscn",
		"death_realm": true
	}
}

var current_level_name = ""
var current_level = null

func change_level(level_name):
	var world = scenes.game_scene.get_node("3d_world/viewport/world")
	if(current_level):
		management.save_characters(current_level_name)
		current_level.name = "_level"
		management.unmake_player()
		world.call_deferred("remove_child", current_level)
		current_level.call_deferred("free")
	current_level_name = level_name
	var path = levels[level_name]["path"]
	current_level = load(path).instance()
	current_level.name = "level"
	var spawn = current_level.get_node_or_null("player_spawn")
	management.player_spawn_position = spawn.translation if(spawn != null) else management.player.translation
	errors.log("change level: " + current_level_name)
	world.call_deferred("add_child", current_level)
	management.call_deferred("init_characters", current_level, current_level_name, levels[current_level_name]["death_realm"])
	#management.camera.last_obstructing_objects.clear() # todo: use when using top-down-camera
