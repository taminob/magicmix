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
			spawned_characters.push_back(x.name)
		else:
			errors.assert(false, "character " + x.name + " in death_realm is not dead!")

	for dead_name in dead_characters:
		if(!spawned_characters.has(dead_name)):
			var new_char = game.mgmt.create_character(dead_name)
			add_child(new_char)
			new_char.translation = next_spawn_position
			next_spawn_position += Vector3(0, 0, 1)
