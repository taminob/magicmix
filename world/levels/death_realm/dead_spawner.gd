extends Spatial

export var radius: float = 1.0

func _ready():
	var dead_characters: Array = []
	for x in game.char_data.keys():
		if(game.get_character(x).get("stats", {}).get("dead", false) &&
			!game.get_character(x).get("stats", {}).get("undead", false)):
			dead_characters.push_back(x)

	var spawned_characters: Array = []
	for x in get_tree().get_nodes_in_group("characters"):
		if(dead_characters.has(x.name)):
			spawned_characters.push_back(x.name)
		else:
			errors.assert(false, "character " + x.name + " in death_realm is not dead!")

	var _next_spawn_position: Vector3 = Vector3.ZERO
	var i: int = 0
	for dead_name in dead_characters:
		if(!spawned_characters.has(dead_name)):
			var new_char: character = game.mgmt.create_character(dead_name)
			add_child(new_char)
			new_char.translation = radius * Vector3(sin(float(i) / dead_characters.size() * TAU), 0, cos(float(i) / dead_characters.size() * TAU))
			new_char.face_target(self)
		i += 1
