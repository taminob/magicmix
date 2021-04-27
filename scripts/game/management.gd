extends Node

var player_name = ""
var player = null
var camera = load("res://characters/player/camera.tscn").instance()
var character_class = load("res://characters/character.gd")
var character_scene = load("res://characters/character.tscn")
var player_spawn_position = Vector3.ZERO

func is_player(node):
	return node == player && player

func make_player(character):
	if(character == player || !character):
		return
	if(player):
		unmake_player()
	player_name = character.name
	player = character
	player.add_child(camera)
	#player.set_script(player_class)
	player.is_player = true
	#player.camera_pivot = camera

func unmake_player():
	if(!player):
		return
	player.call_deferred("remove_child", camera)
	#player.set_script(character_class)
	player.is_player = false
	player = null

func create_player(level_name):
	var player_data = characters.characters[player_name]
	var new_player = character_scene.instance()
	new_player.name = player_name
	new_player.add_to_group("characters")
	make_player(new_player)
	set_character_data(player, level_name)
	player.translation = player_spawn_position

func init_characters(level, level_name, death_realm=false):
	for character in get_tree().get_nodes_in_group("characters"):
		if(character.name == player_name):
			player_spawn_position = character.translation
			make_player(character)
			player.translation = player_spawn_position
		set_character_data(character, level_name)
		character.in_death_realm = death_realm
	if(!player):
		create_player(level_name)
		level.call_deferred("add_child", player)
		set_character_data(player, level_name)
		player.in_death_realm = death_realm

func save_characters(level_name):
	for character in get_tree().get_nodes_in_group("characters"):
		characters.characters[character.name]["dead"] = character.dead
		characters.characters[character.name]["pain"] = character.pain
		characters.characters[character.name]["focus"] = character.focus
		characters.characters[character.name]["velocity"] = character.velocity
		characters.characters[character.name]["translations"][level_name] = character.translation

func set_character_data(character, level_name):
	var char_data = characters.characters[character.name]
	if(char_data["dead"]):
		character.dead = true
	character.velocity = char_data["velocity"]
	character.translation = char_data["translations"].get(level_name, character.translation)
	character.pain = char_data["pain"]
	character.focus = char_data["focus"]

	if(character != player):
		# todo: init inventory?
		pass
