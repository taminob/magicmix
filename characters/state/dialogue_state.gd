extends Node

class_name dialogue_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var stats: Node = $"../stats"

const DIALOGUE_NO_FADE_DISTANCE_SQRD = 25;
const DIALOGUE_END_DISTANCE_SQRD = 100;

var display_name: String
var call_names: Dictionary
var gender: String
var job: String
var partner: KinematicBody
var listeners: Array
var data: abstract_dialogue

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

var current_statement: abstract_dialogue.statement
var end_dialogue: bool = false
func dialogue_process(_delta: float):
	if(!is_dialogue_active()):
		return # TODO: fade if listener goes away
	var dist = partner.global_transform.origin.distance_squared_to(pawn.global_transform.origin)
	dist = (dist - DIALOGUE_NO_FADE_DISTANCE_SQRD) / DIALOGUE_END_DISTANCE_SQRD
	var dialogue_intensity = 1 - clamp(dist, 0, 1)
	if(dialogue_intensity <= 0):
		interrupt_dialogue()

func dialogue_interacted(interactor: KinematicBody):
	if(!can_talk()):
		return
	if(!is_dialogue_active()):
		if(interactor.state.is_player):
			start_dialogue(interactor)
		else:
			interactor.dialogue.start_dialogue(pawn)
	elif(partner == interactor):
		partner.dialogue.choose_statement([]) # todo: rework
	else:
		add_listener(interactor)

func is_dialogue_active() -> bool:
	return game.is_valid(partner)

func is_data_provider() -> bool:
	return data.partner != null

func can_talk() -> bool:
	return !stats.dead || stats.undead || game.levels.current_level_death_realm

func player_in_dialogue() -> bool:
	return is_dialogue_active() && (state.is_player || partner.state.is_player)

func start_dialogue(new_partner: KinematicBody):
	interrupt_dialogue()
	partner = new_partner
	data.change_partner(partner)
	pawn.face_target(partner) # todo? keep facing partner during entire dialogue?
	partner.dialogue.accept_dialogue(pawn)
	if(player_in_dialogue()):
		game.mgmt.ui.start_dialogue()
	say()

func accept_dialogue(new_partner: KinematicBody):
	partner = new_partner

func say():
	current_statement = data.get_statement()
	partner.dialogue.receive_statement(current_statement)
	update_listeners(current_statement)

func choose_statement(statements: Array):
	if(!is_dialogue_active()):
		return
	if(!game.mgmt.ui.dialogue.fully_visible()):
		game.mgmt.ui.dialogue.set_progress(-1)
		return
	if(end_dialogue):
		end_dialogue()
		return
	var response: abstract_dialogue.statement
	if(state.is_player):
		response = game.mgmt.ui.dialogue.get_current_response()
	else:
		response = statements.front() # todo: ai select answer
	partner.dialogue.receive_statement(response)

func receive_statement(statement: abstract_dialogue.statement):
	if(is_data_provider()):
		data.set_response(statement)
	else:
		partner.dialogue.data.set_response(statement)
	if(state.is_player):
		game.mgmt.ui.dialogue.set_dialogue_text(statement.formatted_text(), get_call_name(statement.speaker.name), statement.responses) # TODO: check is_valid for statements in responses
	else:
		if(is_dialogue_active()):
			if(!statement.next_statement.empty()):
				choose_statement([data.statement_path_to_statement(statement.next_statement)])
			else:
				choose_statement(statement.responses) # TODO: ai answer selection, wait for player
	statement.execute_effects(pawn)

func listen(statement: abstract_dialogue.statement):
	if(state.is_player):
		game.mgmt.ui.dialogue.set_dialogue_text(statement.formatted_text(), get_call_name(statement.speaker.name), [])
	statement.execute_effects(pawn)

func add_listener(listener: KinematicBody):
	if(!listeners.has(listener)):
		listeners.push_back(listener)
	if(listener.state.is_player):
		game.mgmt.ui.start_dialogue()
		if(current_statement):
			say()
	if(current_statement):
		update_listeners(current_statement)
	elif(is_dialogue_active() && partner.dialogue._current_statement):
		update_listeners(partner.dialogue._current_statement)

func update_listeners(statement: abstract_dialogue.statement):
	if(statement):
		for x in listeners:
			x.dialogue.listen(statement, [])
			statement.execute_effects(x)
		if(partner):
			for x in partner.dialogue.listeners:
				x.dialogue.listen(statement, [])
				statement.execute_effects(x)

func interrupt_dialogue():
	end_dialogue()

func end_dialogue():
	end_dialogue = false
	if(!is_dialogue_active()):
		return
	current_statement = null
	if(state.is_player):
		game.mgmt.ui.end_dialogue()
	if(partner):
		var old_partner = partner
		partner = null
		data.change_partner(null)
		old_partner.dialogue.end_dialogue()
#	var i: int = 0
#	while i < listeners.size():
#		var listener = listeners[i]
#		listeners.remove(i)
#		listener.end_dialogue()
	listeners.clear()

func get_call_name(character_id: String) -> String:
	return call_names.get(character_id, "???") # todo: add question for name if unknown

func get_relationship(character_id: String) -> float:
	return relationships.get(character_id, base_relationship)

func get_relation(character_id: String) -> int:
	return relations.get(character_id, relation.neutral) # todo: check for tags (e.g. criminal)

func set_relation(character_id: String, relation: int):
	relations[character_id] = relation

func save(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	_dialogue_state["name"] = display_name
	_dialogue_state["gender"] = gender
	_dialogue_state["job"] = job
	if(is_dialogue_active()):
		_dialogue_state["dialogue_partner"] = partner.name # TODO: dialogue restore does not work (partner found, but dialogue not started)
	#_dialogue_state["dialogue_listeners"] = listeners
	_dialogue_state["call_names"] = call_names
	_dialogue_state["relationships"] = relationships
	_dialogue_state["base_relationship"] = base_relationship
	_dialogue_state["relations"] = relations
	_dialogue_state["current_dialogues"] = data.partners
	state_dict["dialogue"] = _dialogue_state

func init(state_dict: Dictionary):
	var _dialogue_state = state_dict.get("dialogue", {})
	display_name = _dialogue_state.get("name", "")
	gender = _dialogue_state.get("gender", "")
	job = _dialogue_state.get("job", "")
	partner = game.get_character(_dialogue_state.get("dialogue_partner", ""))
	#listeners = _dialogue_state.get("dialogue_listeners", [])
	call_names = _dialogue_state.get("call_names", {})
	relationships = _dialogue_state.get("relationships", {})
	base_relationship = _dialogue_state.get("base_relationship", 0)
	relations = _dialogue_state.get("relations", {}) # todo? fix enum type, json parsing might result in floats instead of ints
	#_dialogue = load(_dialogue_state.get("dialogue", "res://characters/dialogue/default/dialogue.gd")).new()
	if(ResourceLoader.exists("res://characters/dialogue/" + pawn.name + "/dialogue.gd")):
		data = load("res://characters/dialogue/" + pawn.name + "/dialogue.gd").new()
	else:
		data = load("res://characters/dialogue/default/dialogue.gd").new()
	data.init(pawn, _dialogue_state.get("current_dialogues", {}))
