extends Spatial

export var next_level: String
export var next_character_name: String

func _ready():
	if(next_character_name.empty()):
		next_character_name = game.mgmt.player_name
	assert(game.char_data.has(next_character_name), "target character name of portal does not exist")
	assert(game.levels.levels.has(next_level), "target level of portal does not exist")

func get_interaction() -> String:
	return game.char_data[next_character_name]["dialogue"]["name"]

func interact(_interactor: character):
	pass

func _on_area_body_entered(body):
	# todo: make revive mechanic more robust to non-existent entries in dictionaries
	if(body == null || body != game.mgmt.player):
		return
	errors.log("revive: " + next_character_name)
	if(body.name == next_character_name):
		body.revive()
	else: # todo: when character is dead, these changes will be reverted in save_characters in change_level
		game.char_data[next_character_name]["stats"]["pain"] = 0.0
		game.char_data[next_character_name]["stats"]["dead"] = false
		game.char_data[body.name]["move"]["translations"].erase(game.levels.current_level_name)
	var spawn = game.levels.current_level.get_node_or_null("player_spawn")
	if(spawn):
		body.translation = spawn.translation
	game.char_data[next_character_name]["move"]["translations"].clear()
	game.mgmt.player_name = next_character_name
	game.levels.change_level(next_level)
