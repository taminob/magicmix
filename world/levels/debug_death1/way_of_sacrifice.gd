extends CSGMesh

onready var player_spawn = $"../player_spawn"

func _on_trigger_body_entered(body, name):
	# todo: make revive mechanic more robust to non-existent entries in dictionaries
	if(body == null || body != game.mgmt.player):
		return
	errors.log("revive: " + name)
	if(body.name == name):
		body.revive()
	else: # todo: when character is dead, these changes will be reverted in save_characters in change_level
		game.char_data[name]["stats"]["pain"] = 0.0
		game.char_data[name]["stats"]["dead"] = false
		game.char_data[body.name]["move"]["translations"].erase(game.levels.current_level_data.id())
	body.translation = player_spawn.translation
	game.char_data[name]["move"]["translations"].clear()
	game.mgmt.player_id = name
	game.levels.change_level("debug1")
