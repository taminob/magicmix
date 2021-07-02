extends Node

class_name interaction_state

onready var state: Node = get_parent()
onready var character: character = $"../.."
onready var inventory: Node = $"../inventory"
onready var stats: Node = $"../stats"
onready var move: Node = $"../move"

var interact_target: Node = null

func initiate_interact():
	if(interact_target):
		interact_target.interact(character)

func consume(item: String, remove_from_inventory:bool=true):
	if(items.items[item]["category"] != "consumable"):
		return
	if(remove_from_inventory):
		inventory.things.erase(item)
	stats._self_damage(items.items[item]["self"]["pain"])

func toggle_spirit():
	state.is_spirit = !state.is_spirit
	if(state.is_spirit):
		#var spirit_node: Node =  character.get_node("spirit")
		character.spirit = load("res://characters/spirit.tscn").instance()
		character.spirit.translation = character.translation + 2 * Vector3.UP
		character.spirit.set_name(character.name + "_spirit")
		character.spirit.character = character
		character.get_parent().add_child(character.spirit)
		if(state.is_player):
			#character.remove_child(game.mgmt.camera)
			#spirit_node.add_child(game.mgmt.camera)
			var spirit_camera = load("res://characters/player/camera.tscn").instance()
			spirit_camera.set_name("spirit_camera")
			spirit_camera.rotation_axes = Vector2(1, 1)
			character.spirit.add_child(spirit_camera)
			spirit_camera.make_current()
	else:
		character.spirit.queue_free()
		character.spirit = null
		move.spirit_velocity = Vector3.ZERO
		if(state.is_player):
			#spirit_node.remove_child(game.mgmt.camera)
			#character.add_child(game.mgmt.camera)
			game.mgmt.camera.make_current()
			#spirit_node.translation = Vector3(0, 2, 0)
			#spirit_node.rotation = Vector3.ZERO

func _on_interact_zone_entered(body_or_area: Node):
	if(body_or_area && body_or_area.has_method("interact") && body_or_area != character):
		interact_target = body_or_area
		if(state.is_player):
			game.mgmt.ui.show_interaction(body_or_area.get_interaction(), null)

# todo: if there is another target still in zone, switch to it
func _on_interact_zone_exited(body_or_area: Node):
	if(interact_target == body_or_area):
		interact_target = null
		if(state.is_player):
			game.mgmt.ui.hide_interaction()
