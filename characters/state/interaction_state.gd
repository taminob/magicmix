extends Node

onready var state = get_parent()
onready var character = $"../.."
onready var dialogue = $"../dialogue"

var interact_target = null

# warning-ignore:unused_class_variable
var interaction_options = {
	"": null,
	"Talk": funcref(self, "talk"),
	"Open": funcref(self, "open")
}

func interact():
	if(dialogue.end_dialogue()):
		return

	if(!interact_target):
		return
	interact_target.interact(character)
	interaction_options[interact_target.interaction_name].call_func()

func talk():
	errors.log("starting conversation!")

func open():
	errors.log("opening box!")

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
