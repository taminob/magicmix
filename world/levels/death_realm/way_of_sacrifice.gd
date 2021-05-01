extends CSGMesh

onready var player_spawn = $"../player_spawn"

func _on_trigger_body_entered(body, name):
	if(body == null || body != management.player):
		return
	errors.log("revive: " + name)
	if(body.name == name):
		body.pain = 0.0
		body.dead = false
	else: # todo: when character is dead, these changes will be reverted in save_characters in change_level
		characters.characters[name]["pain"] = 0.0
		characters.characters[name]["dead"] = false
		characters.characters[body.name]["translations"].erase(levels.current_level_name)
	body.translation = player_spawn.translation
	characters.characters[name]["translations"].clear()
	management.player_name = name
	levels.change_level("intro")
	#inventory.change_level(load("res://world/death_realm/death_realm.tscn").instance())
#	body.pain = 0.0
#	body.dead = false
#	body.in_death_realm = false
