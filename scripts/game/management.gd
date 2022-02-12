extends Node

var player_id: String = ""
var player: KinematicBody = null
# warning-ignore:unused_class_variable
var player_history: Array
# warning-ignore:unused_class_variable
var player_logs: Dictionary
# warning-ignore:unused_class_variable
var time_paused: bool = false
var camera: Node = load("res://characters/player/camera.tscn").instance()
var character_scene: PackedScene = load("res://characters/character.tscn")
# warning-ignore:unused_class_variable
var ui: ui = null

enum layer_bit {
	default = 0,
	static_world = 1,
	objects = 2,
	characters = 3,
	enemies = 4,
	spirits = 5,
	spells = 6,
	camera = 7,
}

enum layer {
	default = 1 << layer_bit.default,
	static_world = 1 << layer_bit.static_world,
	objects = 1 << layer_bit.objects,
	characters = 1 << layer_bit.characters,
	enemies = 1 << layer_bit.enemies,
	spirits = 1 << layer_bit.spirits,
	spells = 1 << layer_bit.spells,
	camera = 1 << layer_bit.camera,

	ALL = 0xFFFF
}

const physical_layers = layer.default | layer.static_world | layer.objects | layer.characters | layer.enemies
const damage_layers = layer.objects | layer.characters | layer.enemies

func is_player(node) -> bool:
	return node == player && player

func _set_player_flag(target: KinematicBody, is_player: bool):
	if(target.state):
		target.set_player(is_player)
	else:
		errors.error_test(target.connect("ready", target, "set_player", [is_player]))

func make_player(new_player: KinematicBody):
	if(!new_player):
		return
	if(player):
		unmake_player()
	player_id = new_player.name
	player = new_player
	player.call_deferred("add_child", camera)
	player.get_node("health_bar").set_visible(false)
	player.get_node("shield_bar").set_visible(false)
	player.get_node("focus_bar").set_visible(false)
	_set_player_flag(player, true)

func unmake_player():
	if(!player || !is_instance_valid(player)):
		return
	player.call_deferred("remove_child", camera)
	player.get_node("health_bar").set_visible(true)
	player.get_node("shield_bar").set_visible(true)
	player.get_node("focus_bar").set_visible(true)
	_set_player_flag(player, false)
	player = null

func create_player():
	make_player(create_character(player_id))

func create_character(character_name: String) -> KinematicBody:
	var new_character = character_scene.instance()
	new_character.name = character_name
	new_character.add_to_group("characters")
	return new_character

func save_characters():
	# todo? performance difference between call_group and get_nodes_in_group?
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "characters", "save_state")
	for x in get_tree().get_nodes_in_group("characters"):
		x.save_state()
		x.reset()

func call_delayed(caller: Object, method: String, time: float, param: Array=[]):
	errors.error_test(get_tree().create_timer(time).connect("timeout", caller, method, param))
