extends Node

var player_name: String = ""
var player: KinematicBody = null
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

func _set_player_flag(target, is_player):
	if(target.state):
		target.set_player(is_player)
	else:
		errors.error_test(target.connect("ready", target, "set_player", [is_player]))

func make_player(character):
	if(!character):
		return
	if(player):
		unmake_player()
	player_name = character.name
	player = character
	player.call_deferred("add_child", camera)
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
	for x in get_tree().get_nodes_in_group("characters"):
		x.save_state()
		x.reset()

func call_delayed(caller: Object, method: String, time: float, param: Array=[]):
	errors.error_test(get_tree().create_timer(time).connect("timeout", caller, method, param))
