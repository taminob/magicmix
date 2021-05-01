extends Node

onready var state = get_parent()

var display_name
var gender
var dialogue_partners

func start_dialogue(actor):
	end_dialogue()
	dialogue_partners.push_back(actor)

func end_dialogue():
	for x in dialogue_partners:
		# TODO: might cause seg faul because of erase in loop
		dialogue_partners.erase(x)
		x.end_dialogue()

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
