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
