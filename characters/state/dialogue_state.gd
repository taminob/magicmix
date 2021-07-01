extends Node

class_name dialogue_state

onready var state: Node = get_parent()
onready var character: character = $"../.."

var display_name: String
var gender: String
var dialogue_partners: Array
var current_dialogue: int
var _dialogues: Dictionary

var dialogue_progress: float = 0
var dialogue_length: int = 0
func dialogue_process(delta: float):
	for x in dialogue_partners:
		# todo: distance_squared_to
		var t = (x.character.translation.distance_squared_to(character.translation) - 25)/100
		var dialogue_intensity = 1 - clamp(t, 0, 1)
		if(dialogue_intensity <= 0):
			# warning-ignore:return_value_discarded
			end_dialogue()
			if(state.is_player):
				game.mgmt.ui.end_dialogue()
		if(state.is_player):
			dialogue_progress += min(delta * 10, dialogue_length)
			game.mgmt.ui.update_dialogue(dialogue_progress, dialogue_intensity)

func start_dialogue(other_dialogue_state: dialogue_state):
	# warning-ignore:return_value_discarded
	end_dialogue()
	dialogue_progress = 0
	dialogue_partners.push_back(other_dialogue_state)
	if(state.is_player):
		show_current_dialogue(other_dialogue_state)
		game.mgmt.ui.start_dialogue()

func answer_selected(num: int):
	var other_dialogue = dialogue_partners.back()._dialogues
	if(num < 0 || num >= other_dialogue.size()):
		# warning-ignore:return_value_discarded
		end_dialogue()
		return
	dialogue_partners.back().current_dialogue = num
	show_current_dialogue(dialogue_partners.back())

func show_current_dialogue(other_dialogue_state: dialogue_state):
	var other_dialogue: Dictionary = other_dialogue_state._dialogues[other_dialogue_state.current_dialogue]
	dialogue_progress = 0
	game.mgmt.ui.set_dialogue_text(other_dialogue["say"], other_dialogue.get("name", other_dialogue_state.display_name), other_dialogue.get("answers", []), funcref(self, "answer_selected"))
	dialogue_length = other_dialogue["say"].length() # todo? dont count bbcode tags (if tags are allowed in dialogue)

func end_dialogue() -> bool:
	if(dialogue_partners.empty()):
		return false
	if(dialogue_progress < dialogue_length):
		dialogue_progress = dialogue_length
		return true
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
	_dialogue_state["current_dialogue"] = current_dialogue
	state_dict["dialogue"] = _dialogue_state

func init(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	display_name = _dialogue_state.get("name", "")
	gender = _dialogue_state.get("gender", "")
	dialogue_partners = _dialogue_state.get("dialogue_partners", [])
	current_dialogue = _dialogue_state.get("current_dialogue", 0)
	_dialogues = load(_dialogue_state.get("dialogue", "res://characters/dialogue/default/dialogue.gd")).dialogue()
