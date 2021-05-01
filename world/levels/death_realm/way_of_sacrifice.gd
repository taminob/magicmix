extends CSGMesh

onready var player_spawn = $"../player_spawn"

func _on_trigger_body_entered(body, name):
	# todo: make revive mechanic more robust to non-existent entries in dictionaries
	if(body == null || body != management.player):
		return
	errors.log("revive: " + name)
	if(body.name == name):
		body.revive()
	else: # todo: when character is dead, these changes will be reverted in save_characters in change_level
		characters.characters[name]["stats"]["pain"] = 0.0
		characters.characters[name]["stats"]["dead"] = false
		characters.characters[body.name]["move"]["translations"].erase(levels.current_level_name)
	body.translation = player_spawn.translation
	characters.characters[name]["move"]["translations"].clear()
	management.player_name = name
	levels.change_level("intro")
