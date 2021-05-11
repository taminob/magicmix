extends Node

onready var state = get_parent()
onready var character = $"../.."

var display_name
var gender
var dialogue_partners

var dialogue_progress = 0
func dialogue_process(delta):
	for x in dialogue_partners:
		# todo: distance_squared_to
		var t = (x.character.position.distance_to(character.position) - 500)/1000
		var dialogue_intensity = 1 - clamp(t, 0, 1)
		if(dialogue_intensity <= 0):
			end_dialogue()
			if(state.is_player):
				game.mgmt.ui.end_dialogue()
		if(state.is_player):
			dialogue_progress += delta * 10
			game.mgmt.ui.update_dialogue(dialogue_progress, dialogue_intensity)

func start_dialogue(other_dialogue_state):
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
	var i = 0
	while i < dialogue_partners.size():
		var partner = dialogue_partners[i]
		dialogue_partners.remove(i)
		partner.end_dialogue()
	if(state.is_player):
		game.mgmt.ui.end_dialogue()
	return true

func save(_state):
	var _dialogue_state = _state.get("dialogue", {})
	_dialogue_state["name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["dialogue_partners"] = dialogue_partners
	_state["dialogue"] = _dialogue_state

func init(_state):
	var _dialogue_state = _state.get("dialogue", {})
	display_name = _state["dialogue"].get("name", "")
	gender = _state["dialogue"].get("gender", "")
	dialogue_partners = _state["dialogue"].get("dialogue_partners", [])
