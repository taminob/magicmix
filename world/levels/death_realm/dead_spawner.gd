extends Spatial

var next_spawn_position: Vector3 = Vector3.ZERO

func _ready():
	var dead_characters: Array = []
	for x in game.char_data.keys():
		if(game.get_character(x).get("stats", {}).get("dead", false)):
			dead_characters.push_back(x)

	var spawned_characters: Array = []
	for x in get_tree().get_nodes_in_group("characters"):
		if(dead_characters.has(x.name)):
			spawned_characters.push_back(x)
		else:
			errors.assert(false, "character in death_realm is not dead!")

	for x in dead_characters:
		if(!spawned_characters.has(x)):
			var new_char = preload("res://characters/character.tscn").instance()
			new_char.name = x
			add_child(new_char)
			new_char.translation = next_spawn_position
			next_spawn_position += Vector3(0, 0, 1)
