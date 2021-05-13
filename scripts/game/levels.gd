extends Node

var levels = {
	"intro": {
		"path": "res://world/levels/intro/level.tscn",
		"death_realm": false
	},
	"death_realm": {
		"path": "res://world/levels/death_realm/level.tscn",
		"death_realm": true
	}
}

var current_level_name = ""
var current_level = null
var current_level_death_realm = false

func change_level(level_name):
	var world = scenes.game_instance.get_node("world_container/viewport/world")
	if(current_level):
		game.mgmt.save_characters()
		current_level.name = "_level"
		game.mgmt.unmake_player()
		world.call_deferred("remove_child", current_level)
		current_level.call_deferred("free")
	current_level_name = level_name
	current_level = load(levels[level_name]["path"]).instance()
	current_level_death_realm = levels[level_name].get("death_realm", false)
	current_level.name = "level"
	var spawn = current_level.get_node_or_null("player_spawn")
	spawn = spawn.position if(spawn != null) else game.mgmt.player.position
	errors.log("change level: " + current_level_name)
	world.call_deferred("add_child", current_level)
	var new_player = current_level.get_node_or_null(game.mgmt.player_name)
	if(new_player):
		game.mgmt.call_deferred("make_player", new_player)
	else:
		game.mgmt.create_player()
		game.mgmt.player.position = spawn
		current_level.call_deferred("add_child", game.mgmt.player)

	#for character in get_tree().get_nodes_in_group("characters"):
	#game.mgmt.camera.last_obstructing_objects.clear() # todo: use when using top-down-camera