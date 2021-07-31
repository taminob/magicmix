extends Node

class_name dialogue_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var stats: Node = $"../stats"

const DIALOGUE_NO_FADE_DISTANCE_SQRD = 25;
const DIALOGUE_END_DISTANCE_SQRD = 100;
const DIALOGUE_SPEED = 10;

var display_name: String
var call_names: Dictionary
var gender: String
var job: String
var partner: KinematicBody
var listeners: Array
var dialogue_data: abstract_dialogue

var relationships: Dictionary
var base_relationship: float
var relations: Dictionary

enum relation {
	enemy = -2,
	rival = -1, # todo? remove rival/friend level?
	neutral = 0,
	friend = 1,
	ally = 2
}

var _dialogue_progress: float = 0
var _dialogue_length: int = 0
func dialogue_process(delta: float):
	if(!is_dialogue_active()):
		return
	_dialogue_progress = min(_dialogue_progress + delta * DIALOGUE_SPEED, _dialogue_length)
	var dist = partner.global_transform.origin.distance_squared_to(pawn.global_transform.origin)
	dist = (dist - DIALOGUE_NO_FADE_DISTANCE_SQRD) / DIALOGUE_END_DISTANCE_SQRD
	var dialogue_intensity = 1 - clamp(dist, 0, 1)
	if(dialogue_intensity <= 0):
		end_dialogue()
	elif(partner.state.is_player):
		game.mgmt.ui.dialogue.update_dialogue(_dialogue_progress, dialogue_intensity)

func dialogue_interact(interactor: KinematicBody):
	if(!is_dialogue_active() && can_talk() && interactor.dialogue.can_talk()):
		start_dialogue(interactor)
		interactor.dialogue.start_dialogue(pawn)
		if(interactor.state.is_player):
			ask()
		else:
			interactor.dialogue.ask()
	elif(partner == interactor):
		partner.dialogue.answer() # todo: rework

func is_dialogue_active() -> bool:
	return partner != null

func can_talk() -> bool:
	return !stats.dead || stats.undead || game.levels.current_level_death_realm

func start_dialogue(new_partner: KinematicBody):
	end_dialogue()
	partner = new_partner
	dialogue_data.change_partner(partner)
	if(partner.state.is_player):
		game.mgmt.ui.start_dialogue()
		listeners.push_back(game.mgmt.ui)

func ask():
	var current_statement = dialogue_data.dialogue()
	_dialogue_progress = 0
	_dialogue_length = current_statement.formatted_text().length() # todo? dont count bbcode tags (if tags are allowed in dialogue)
	for x in listeners:
		x.dialogue.listen(current_statement)
		current_statement.execute_effects(x)
	partner.dialogue.listen(current_statement)
	current_statement.execute_effects(partner)

func answer():
	if(!is_dialogue_active()):
		return
	if(partner.dialogue._dialogue_progress < partner.dialogue._dialogue_length):
		partner.dialogue._dialogue_progress = partner.dialogue._dialogue_length
		return
	var selected_answer: abstract_dialogue.answer = null
	if(state.is_player):
		selected_answer = game.mgmt.ui.dialogue.get_current_answer_data()
	else:
		selected_answer = null # todo: ai select answer
	partner.dialogue.answer_received(selected_answer)

func answer_received(answer: abstract_dialogue.answer):
	if(!is_dialogue_active()):
		return
	if(answer):
		dialogue_data.transition(answer)
		if(is_dialogue_active()):
			ask()
	else:
		# warning-ignore:return_value_discarded
		end_dialogue()

func listen(_statement: abstract_dialogue.statement):
	if(!state.is_player):
		if(partner):
			answer()

func end_dialogue():
	if(!is_dialogue_active()):
		return
	if(state.is_player):
		game.mgmt.ui.end_dialogue()
	if(partner):
		var old_partner = partner
		partner = null
		old_partner.dialogue.end_dialogue()
	var i: int = 0
	while i < listeners.size():
		var listener = listeners[i]
		listeners.remove(i)
		listener.end_dialogue()

func get_call_name(id: String) -> String:
	return call_names.get(id, "???") # todo: add question for name if unknown

func get_relationship(id: String) -> float:
	return relationships.get(id, base_relationship)

func get_relation(id: String) -> int:
	return relations.get(id, relation.neutral) # todo: check for tags (e.g. criminal)

func save(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	_dialogue_state["name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["job"] = job
	#_dialogue_state["dialogue_partner"] = partner # todo? save currently active dialogue
	#_dialogue_state["dialogue_listeners"] = listeners
	_dialogue_state["call_names"] = call_names
	_dialogue_state["relationships"] = relationships
	_dialogue_state["base_relationship"] = base_relationship
	_dialogue_state["relations"] = relations
	_dialogue_state["current_dialogues"] = dialogue_data._partners
	state_dict["dialogue"] = _dialogue_state

func init(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	display_name = _dialogue_state.get("name", "")
	gender = _dialogue_state.get("gender", "")
	job = _dialogue_state.get("job", "")
	#partner = _dialogue_state.get("dialogue_partner", null)
	#listeners = _dialogue_state.get("dialogue_listeners", [])
	call_names = _dialogue_state.get("call_names", {})
	relationships = _dialogue_state.get("relationships", {})
	base_relationship = _dialogue_state.get("base_relationship", 0)
	relations = _dialogue_state.get("relations", {}) # todo? fix enum type, json parsing might result in floats instead of ints
	#_dialogue = load(_dialogue_state.get("dialogue", "res://characters/dialogue/default/dialogue.gd")).new()
	if(ResourceLoader.exists("res://characters/dialogue/" + pawn.name + "/dialogue.gd")):
		dialogue_data = load("res://characters/dialogue/" + pawn.name + "/dialogue.gd").new()
	else:
		dialogue_data = load("res://characters/dialogue/default/dialogue.gd").new()
	dialogue_data.init(pawn, _dialogue_state.get("current_dialogues", {}))
