extends Node

class_name interaction_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var inventory: Node = $"../inventory"
onready var stats: Node = $"../stats"
onready var move: Node = $"../move"

var interact_target: Node = null

func initiate_interact():
	if(interact_target):
		interact_target.interact(pawn)

func consume(item: String, remove_from_inventory: bool=true):
	if(item_data.items[item].category() != "consumable"):
		return
	if(remove_from_inventory):
		inventory.things.erase(item)
	# todo? elemental damage from item
	stats._self_damage(item_data.items[item].self_pain())
	stats._self_focus_damage(item_data.items[item].self_focus())
	# todo: damage over time

func toggle_spirit():
	state.is_spirit = !state.is_spirit
	# todo: pause when entering spirit mode; do not use pause_mode, causes problems with input; solution maybe introducing pause_game in game.mgmt

	if(state.is_spirit):
		pawn.spirit = load("res://characters/spirit.tscn").instance()
		pawn.spirit.translation = pawn.translation + 2 * Vector3.UP
		pawn.spirit.set_name(pawn.name + "_spirit")
		pawn.spirit.pawn = pawn
		pawn.get_parent().add_child(pawn.spirit)
		if(state.is_player):
			var spirit_camera = load("res://characters/player/camera.tscn").instance()
			spirit_camera.set_name("spirit_camera")
			spirit_camera.rotation_axes = Vector2(1, 1)
			pawn.spirit.add_child(spirit_camera)
			spirit_camera.make_current()
	else:
		pawn.spirit.queue_free()
		pawn.spirit = null
		move.spirit_velocity = Vector3.ZERO
		if(state.is_player):
			game.mgmt.camera.make_current()

func _on_interact_zone_entered(body_or_area: Node):
	if(body_or_area && body_or_area.has_method("interact") && body_or_area != pawn):
		interact_target = body_or_area
		if(state.is_player):
			game.mgmt.ui.show_interaction(body_or_area.get_interaction(), null)

# todo: if there is another target still in zone, switch to it
func _on_interact_zone_exited(body_or_area: Node):
	if(interact_target == body_or_area):
		interact_target = null
		if(state.is_player):
			game.mgmt.ui.hide_interaction()
