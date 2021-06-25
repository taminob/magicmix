extends Node

class_name interaction_state

onready var state: Node = get_parent()
onready var character: character = $"../.."
onready var inventory: Node = $"../inventory"
onready var stats: Node = $"../stats"
onready var dialogue: Node = $"../dialogue"

var interact_target: Node = null

func interact():
	if(dialogue.end_dialogue()):
		return

	if(!interact_target):
		return
	interact_target.interact(character)

func consume(item: String, remove_from_inventory:bool=true):
	if(items.items[item]["category"] != "consumable"):
		return
	if(remove_from_inventory):
		inventory.things.erase(item)
	stats._self_damage(items.items[item]["self"]["pain"])

func toggle_spirit():
	var spirit_node = character.get_node("spirit")
	state.is_spirit = !state.is_spirit
	spirit_node.visible = state.is_spirit
	if(state.is_spirit):
		#character.remove_child(game.mgmt.camera)
		#spirit_node.add_child(game.mgmt.camera)
		var spirit_camera = load("res://characters/player/camera.tscn").instance()
		spirit_camera.set_name("spirit_camera")
		spirit_camera.rotation_axes = Vector2(1, 1)
		spirit_node.add_child(spirit_camera)
		spirit_camera.make_current()
	else:
		#spirit_node.remove_child(game.mgmt.camera)
		#character.add_child(game.mgmt.camera)
		spirit_node.remove_child(spirit_node.get_node("spirit_camera"))
		game.mgmt.camera.make_current()
		spirit_node.translation = Vector3(0, 2, 0)
		spirit_node.rotation = Vector3.ZERO
		

func _on_interact_zone_body_entered(body: Node):
	if(body && body.has_method("interact") && body != character):
		interact_target = body
		if(state.is_player):
			game.mgmt.ui.show_interaction(body.interaction_name, null)

# todo: if there is another target still in zone, switch to it
func _on_interact_zone_body_exited(body: Node):
	if(interact_target == body):
		interact_target = null
		if(state.is_player):
			game.mgmt.ui.hide_interaction()
