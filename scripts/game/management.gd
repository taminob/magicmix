extends Node

var player_name = ""
var player = null
var camera = Camera2D.new()#load("res://characters/player/camera.tscn").instance()
var character_scene = load("res://characters/character.tscn")
# warning-ignore:unused_class_variable
var ui = null

func is_player(node):
	return node == player && player

func _set_player_flag(target, is_player):
	if(target.state):
		target.set_player(is_player)
	else:
		target.connect("ready", target, "set_player", [is_player])

func make_player(character):
	if(!character):
		return
	if(player):
		unmake_player()
	player_name = character.name
	player = character
	player.call_deferred("add_child", camera)
	camera.make_current()
	player.get_node("health_bar").set_visible(false)
	_set_player_flag(player, true)

func unmake_player():
	if(!player || !is_instance_valid(player)):
		return
	player.call_deferred("remove_child", camera)
	player.get_node("health_bar").set_visible(true)
	_set_player_flag(player, false)
	player = null

func create_player():
	var new_player = character_scene.instance()
	new_player.name = player_name
	new_player.add_to_group("characters")
	make_player(new_player)

func save_characters():
	for character in get_tree().get_nodes_in_group("characters"):
		character.save_state()

func call_delayed(caller, method, param, time):
	if(param):
# warning-ignore:return_value_discarded
		get_tree().create_timer(time).connect("timeout", caller, method, [param])
	else:
# warning-ignore:return_value_discarded
		get_tree().create_timer(time).connect("timeout", caller, method)