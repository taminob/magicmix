extends Node

onready var state = get_parent()
onready var character = $"../.."

var interact_target = null

var display_name
var gender
var dialogue_partners

func dialogue_process(delta):
	for x in dialogue_partners:
		# todo: distance_squared_to
		var t = (x.character.position.distance_to(character.position) - 500)/1000
		var dialogue_intensity = 1 - clamp(t, 0, 1)
		if(dialogue_intensity <= 0):
			end_dialogue()
			if(state.is_player):
				management.ui.end_dialogue()
		if(state.is_player):
			management.ui.update_dialogue(17, dialogue_intensity)

func interact():
	if(!dialogue_partners.empty()):
		# todo: skip talk animation
		end_dialogue()
		return

	if(!interact_target):
		return
	start_dialogue(interact_target.dialogue)
	interact_target.dialogue.start_dialogue(self)

func start_dialogue(other_dialogue_state):
	end_dialogue()
	dialogue_partners.push_back(other_dialogue_state)
	if(state.is_player):
		management.ui.set_dialogue_text()
		management.ui.start_dialogue()

func end_dialogue():
	var i = 0
	while i < dialogue_partners.size():
		var partner = dialogue_partners[i]
		dialogue_partners.remove(i)
		partner.end_dialogue()

func _on_interact_zone_area_entered(area):
	var target = area.get_parent()
	if(target && target.has_method("interact")):
		interact_target = target
		if(state.is_player):
			management.ui.show_interaction(target.interaction_name, null)

func _on_interact_zone_area_exited(area):
	if(interact_target == area.get_parent()):
		interact_target = null
		if(state.is_player):
			management.ui.hide_interaction()

func save(_state):
	var _dialogue_state = _state.get("dialogue", {})
	_dialogue_state["display_name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["dialogue_partners"] = dialogue_partners
	_state["dialogue"] = _dialogue_state

func init(_state):
	var _dialogue_state = _state.get("dialogue", {})
	display_name = _state["dialogue"].get("display_name", "")
	gender = _state["dialogue"].get("gender", "")
	dialogue_partners = _state["dialogue"].get("dialogue_partners", [])
