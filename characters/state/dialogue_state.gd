extends Node

class_name dialogue_state

onready var state: Node = get_parent()
onready var character: character = $"../.."

var display_name: String
var gender: String
var dialogue_partners: Array

var dialogue_progress: float = 0
func dialogue_process(delta: float):
	for x in dialogue_partners:
		# todo: distance_squared_to
		var t = (x.character.translation.distance_to(character.translation) - 5)/10
		var dialogue_intensity = 1 - clamp(t, 0, 1)
		if(dialogue_intensity <= 0):
			end_dialogue()
			if(state.is_player):
				game.mgmt.ui.end_dialogue()
		if(state.is_player):
			dialogue_progress += delta * 10
			game.mgmt.ui.update_dialogue(dialogue_progress, dialogue_intensity)

func start_dialogue(other_dialogue_state: dialogue_state):
	end_dialogue()
	dialogue_partners.push_back(other_dialogue_state)
	if(state.is_player):
		# todo: dialogue system
		game.mgmt.ui.set_dialogue_text("BLABLABLA", dialogue_partners.back().display_name)
		game.mgmt.ui.start_dialogue()

func end_dialogue():
	if(dialogue_partners.empty()):
		# todo: skip talk animation
		return false
	var i: int = 0
	while i < dialogue_partners.size():
		var partner = dialogue_partners[i]
		dialogue_partners.remove(i)
		partner.end_dialogue()
	if(state.is_player):
		game.mgmt.ui.end_dialogue()
	return true

func save(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	_dialogue_state["name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["dialogue_partners"] = dialogue_partners
	state_dict["dialogue"] = _dialogue_state

func init(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	display_name = _dialogue_state.get("name", "")
	gender = _dialogue_state.get("gender", "")
	dialogue_partners = _dialogue_state.get("dialogue_partners", [])
