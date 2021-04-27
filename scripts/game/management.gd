extends Node

var player_name = ""
var player = null
var camera = load("res://characters/player/camera.tscn").instance()
var player_class = load("res://characters/player/player.gd")
var character_class = load("res://characters/character.gd")
var character_scene = load("res://characters/character.tscn")
var current_level = null
var player_spawn_position = Vector3.ZERO

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
	player.remove_child(camera)
	#player.set_script(character_class)
	player.is_player = false
	player = null

func set_character_data(character):
	var char_data = characters.characters[character.name]
	if(char_data["dead"]):
		character.dead = true
	#character.velocity = char_data["velocity"]
	character.input_direction = Vector3.ZERO
	if(character != player):
		# todo: init inventory?
		pass

func create_player():
	var player_data = characters.characters[player_name]
	var new_player = character_scene.instance()
	new_player.name = player_name
	new_player.add_to_group("characters")
	make_player(new_player)
	set_character_data(player)
	current_level.add_child(player)

func init_characters():
	for character in get_tree().get_nodes_in_group("characters"):
		if(character.name == player_name):
			#player_spawn_position = character.translation # todo: custom player placement
			make_player(character)
			player.translation = player_spawn_position
		set_character_data(character)
	if(!player):
		create_player()

func save_characters():
	for character in get_tree().get_nodes_in_group("characters"):
		characters.characters[character.name]["dead"] = character.dead

func change_level(level):
	var world = scenes.game_scene.get_node("3d_world/viewport/world")
	var old_level = world.get_node_or_null("level")
	save_characters()
	if(player && player_name == player.name):
		if(old_level):
			old_level.remove_child(player)
		level.add_child(player)
	var spawn = level.get_node_or_null("player_spawn")
	player_spawn_position = spawn.translation if(spawn != null) else player.translation
	if(old_level):
		old_level.name = "old_level"
		world.call_deferred("remove_child", old_level)
		old_level.call_deferred("free")
	level.name = "level"
	current_level = level
	world.add_child(current_level)
	init_characters()
