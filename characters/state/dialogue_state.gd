extends Node

class_name dialogue_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."

const DIALOGUE_NO_FADE_DISTANCE_SQRD = 25;
const DIALOGUE_END_DISTANCE_SQRD = 100;
const DIALOGUE_SPEED = 10;

var display_name: String
var gender: String
var job: String
var dialogue_partners: Array
var current_dialogue: int
var _dialogues: Dictionary

var relationships: Dictionary
var base_relationship: float
var relations: Dictionary

enum relation {
	enemy = -2,
	rival = -1,
	neutral = 0,
	friend = 1,
	ally = 2
}

var _dialogue_progress: float = 0
var _dialogue_length: int = 0
func dialogue_process(delta: float):
	for x in dialogue_partners:
		var t = x.pawn.translation.distance_squared_to(pawn.translation)
		t = (t - DIALOGUE_NO_FADE_DISTANCE_SQRD) / DIALOGUE_END_DISTANCE_SQRD
		var dialogue_intensity = 1 - clamp(t, 0, 1)
		if(dialogue_intensity <= 0):
			# warning-ignore:return_value_discarded
			end_dialogue()
			if(state.is_player):
				game.mgmt.ui.end_dialogue()
		if(state.is_player):
			_dialogue_progress = min(_dialogue_progress + delta * DIALOGUE_SPEED, _dialogue_length)
			game.mgmt.ui.dialogue.update_dialogue(_dialogue_progress, dialogue_intensity)

func dialogue_interact(interactor: KinematicBody):
	if(!is_dialogue_active()):
		start_dialogue(interactor.dialogue)
		interactor.dialogue.start_dialogue(self)
	elif(dialogue_partners.has(interactor.dialogue)):
		interactor.dialogue.answer_selected() # todo: rework

func is_dialogue_active() -> bool:
	return !dialogue_partners.empty()

func start_dialogue(other_dialogue_state: dialogue_state):
	# warning-ignore:return_value_discarded
	end_dialogue()
	_dialogue_progress = 0
	dialogue_partners.push_back(other_dialogue_state)
	if(state.is_player):
		show_current_dialogue(other_dialogue_state)
		game.mgmt.ui.start_dialogue()

func answer_selected():
	if(!is_dialogue_active()):
		return
	if(_dialogue_progress < _dialogue_length):
		_dialogue_progress = _dialogue_length
		return
	var next_num = -1
	if(state.is_player):
		next_num = game.mgmt.ui.dialogue.get_current_answer_data()[1]
	var other_dialogue = dialogue_partners.back()._dialogues
	if(next_num < 0 || next_num >= other_dialogue.size()):
		# warning-ignore:return_value_discarded
		end_dialogue()
		return
	dialogue_partners.back().current_dialogue = next_num
	show_current_dialogue(dialogue_partners.back())

func show_current_dialogue(other_dialogue_state: dialogue_state):
	var other_dialogue: Dictionary = other_dialogue_state._dialogues[other_dialogue_state.current_dialogue]
	_dialogue_progress = 0
	game.mgmt.ui.dialogue.set_dialogue_text(other_dialogue["say"], other_dialogue.get("name", other_dialogue_state.display_name), other_dialogue.get("answers", []))
	_dialogue_length = other_dialogue["say"].length() # todo? dont count bbcode tags (if tags are allowed in dialogue)

func end_dialogue():
	var i: int = 0
	while i < dialogue_partners.size():
		var partner = dialogue_partners[i]
		dialogue_partners.remove(i)
		partner.end_dialogue()
	if(state.is_player):
		game.mgmt.ui.end_dialogue()

func get_relationship(id: String) -> float:
	return relationships.get(id, base_relationship)

func get_relation(id: String) -> int:
	return relations.get(id, relation.neutral) # todo: check for tags (e.g. criminal)

func save(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	_dialogue_state["name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["job"] = job
	_dialogue_state["dialogue_partners"] = dialogue_partners
	_dialogue_state["current_dialogue"] = current_dialogue
	_dialogue_state["relationships"] = relationships
	_dialogue_state["base_relationship"] = base_relationship
	_dialogue_state["relations"] = relations
	state_dict["dialogue"] = _dialogue_state

func init(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	display_name = _dialogue_state.get("name", "")
	gender = _dialogue_state.get("gender", "")
	job = _dialogue_state.get("job", "")
	dialogue_partners = _dialogue_state.get("dialogue_partners", [])
	current_dialogue = _dialogue_state.get("current_dialogue", 0)
	relationships = _dialogue_state.get("relationships", {})
	base_relationship = _dialogue_state.get("base_relationship", 0)
	relations = _dialogue_state.get("relations", {}) # todo? fix enum type, json parsing might result in floats instead of ints
	_dialogues = load(_dialogue_state.get("dialogue", "res://characters/dialogue/default/dialogue.gd")).dialogue()
