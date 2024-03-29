extends Spatial

export var next_level: String
export var next_character_name: String

func _ready():
	if(next_character_name.empty()):
		next_character_name = game.mgmt.player_id
	errors.debug_assert(game.char_data.has(next_character_name), "target character name of portal does not exist")
	errors.debug_assert(game.levels.level_data.has(next_level), "target level of portal does not exist")
	var mesh_path = game.get_character_data(next_character_name).get("look", {}).get("mesh_path", "res://characters/meshes/debug/body.tscn")
	var mesh = load(mesh_path).instance()
	mesh.rotate_y(PI)
	add_child(mesh)

func get_interaction() -> String:
	return game.get_character_data(next_character_name)["dialogue"]["name"]

func interact(_interactor: character):
	pass

func _on_area_body_entered(body):
	if(body == null || body != game.mgmt.player):
		return
	errors.log("revive: " + next_character_name)
	if(body.name == next_character_name):
		body.revive()
	else:
		var dead_character: KinematicBody = game.get_character(next_character_name)
		if(dead_character):
			dead_character.revive()
		else:
			var next_stats = game.get_character_data(next_character_name).get("stats", {})
			next_stats["pain"] = 0.0
			next_stats["dead"] = false
			game.get_character_data(next_character_name)["stats"] = next_stats
	var current_move = game.get_character_data(body.name).get("move", {"translations": {}})
	current_move["translations"].erase(game.levels.current_level_data.id()) # reset position to prevent respawn in portal
	game.get_character_data(body.name)["move"] = current_move
	var spawn = game.levels.current_level.get_node_or_null("player_spawn")
	if(spawn):
		body.translation = spawn.translation
	if(game.get_character_data(next_character_name).get("move", {}).has("translations")):
		game.get_character_data(next_character_name)["move"]["translations"].clear()
	game.mgmt.player_id = next_character_name
	game.levels.change_level(next_level)
