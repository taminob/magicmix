extends Node

onready var state = get_parent()
onready var character = $"../.."
onready var inventory = $"../inventory"
onready var stats = $"../stats"
onready var dialogue = $"../dialogue"

var interact_target = null

func interact():
	if(dialogue.end_dialogue()):
		return

	if(!interact_target):
		return
	interact_target.interact(character)

func consume(item, remove_from_inventory=true):
	if(items.items[item]["category"] != "consumable"):
		return
	if(remove_from_inventory):
		inventory.things.erase(item)
	stats._self_damage(items.items[item]["self"]["pain"])

func _on_interact_zone_area_entered(area):
	var target = area.get_parent()
	if(target && target.has_method("interact")):
		interact_target = target
		if(state.is_player):
			game.mgmt.ui.show_interaction(target.interaction_name, null)

# todo: if there is another target still in zone, switch to it
func _on_interact_zone_area_exited(area):
	if(interact_target == area.get_parent()):
		interact_target = null
		if(state.is_player):
			game.mgmt.ui.hide_interaction()
