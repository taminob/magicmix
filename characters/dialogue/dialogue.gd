class_name abstract_dialogue

class statement:
	enum requirements {
		is_player				= 0x0001,
		relationship_enemy		= 0x0002,
		relationship_rival		= 0x0004,
		relationship_neutral	= 0x0008,
		relationship_friend		= 0x0010,
		relationship_ally		= 0x0020,

		ALL						= 0xFFFF
	}
	var path: Array
	var text: String
	var effects: Array
	var speaker: character
	var receiver: character
	var speaker_requires: int
	var receiver_requires: int
	var responses: Array
	var next_statement: Array

	func _init(new_path: Array, new_text: String, new_effects: Array=[], new_responses: Array=[]):
		path = new_path
		text = new_text
		effects = new_effects
		responses = new_responses
		update(null, null)

	func update(new_speaker: character, new_receiver: character):
		speaker = new_speaker
		receiver = new_receiver
		for x in responses:
			x.speaker = receiver
			x.receiver = speaker

	func formatted_text() -> String:
		return text.format({"self": speaker_name(), "partner": receiver_name()}) # todo

	func execute_effects(receiv: character=receiver):
		for x in effects:
			errors.debug_assert(x.is_valid(), "object or function of effect \"" + x.get_function() + "\" for text \"" + text + "\" not valid!")
			x.call_func(receiv)

	func speaker_name() -> String:
		return speaker.dialogue.display_name

	func receiver_name() -> String:
		return speaker.dialogue.get_call_name(receiver.name)

	func is_valid() -> bool:
		return _check_mask_valid(speaker_requires, speaker) && _check_mask_valid(receiver_requires, receiver)

	func _check_mask_valid(mask: int, c: character) -> bool:
		if(mask & requirements.is_player && !c.state.is_player):
			return false
		# todo: other requirements
		return true

	func is_response() -> bool:
		return !(path.back() is String) # todo? is int?

func create_statements_from_dict(statement_dict: Dictionary, path: Array) -> Dictionary:
	var new_dict: Dictionary = {}
	for x in statement_dict.keys():
		if(statement_dict[x].has("say")):
			var new_statement: statement = statement.new(path + [x], statement_dict[x]["say"])
			new_statement.effects = _create_effects(statement_dict[x])
			new_statement.speaker_requires = statement_dict[x].get("speaker_requires", 0)
			new_statement.receiver_requires = statement_dict[x].get("receiver_requires", 0)
			var i: int = 0
			for response_data in statement_dict[x].get("responses", []):
				var new_response: statement = statement.new(path + [x, i], response_data.get("say", ""))
				new_response.next_statement = _create_next(response_data, path, x)
				new_response.effects = _create_effects(response_data)
				new_response.speaker_requires = response_data.get("speaker_requires", 0)
				new_response.receiver_requires = response_data.get("receiver_requires", 0)
				new_statement.responses.push_back(new_response)
				i += 1
			if(new_statement.responses.empty()):
				new_statement.next_statement = _create_next(statement_dict[x], path, x)
			new_dict[x] = new_statement
		else:
			new_dict[x] = create_statements_from_dict(statement_dict[x], path + [x])
	return new_dict

func _create_effects(dict: Dictionary) -> Array:
	var new_effects = dict.get("effects", [])
	if(new_effects is String):
		return [funcref(self, new_effects)]
	elif(new_effects is Array):
		var effects: Array = []
		for effect in new_effects:
			effects.push_back(funcref(self, effect))
		return effects
	elif(new_effects is FuncRef):
		return [new_effects]
	else:
		errors.debug_assert(false, "invalid type for new_effects")
		return []

func _create_next(dict: Dictionary, path: Array, current_key: String) -> Array:
	var new_next = dict.get("next", path + [current_key])
	if(new_next is String):
		return path + [new_next]
	return new_next

var partners: Dictionary
var wants_to_talk_to: Array

var pawn: character
var partner: character

func _end_dialogue(receiver: character):
	receiver.dialogue.wants_to_end_dialogue = true

func _introduce_self(receiver: character=partner):
	if(receiver):
		receiver.dialogue.call_names[pawn.name] = pawn.dialogue.display_name

func _introduce_partner(_receiver: character):
	pawn.dialogue.call_names[partner.name] = partner.dialogue.display_name

func _no_more_want_to_talk_to_partner(_receiver: character):
	if(wants_to_talk_to.has(partner.name)):
		wants_to_talk_to.erase(partner.name)

func _make_enemy(receiver: character):
	if(receiver == partner):
		pawn.dialogue.set_relation(receiver.name, -2)#dialogue_state.relation.enemy) # TODO: move relation to other script to access here

func _become_enemy(receiver: character):
	if(receiver == partner):
		receiver.dialogue.set_relation(pawn.name, -2)#dialogue_state.relation.enemy)

func _make_neutral(receiver: character):
	if(receiver == partner):
		pawn.dialogue.set_relation(receiver.name, 0)#dialogue_state.relation.neutral)

func _become_neutral(receiver: character):
	if(receiver == partner):
		receiver.dialogue.set_relation(pawn.name, 0)#dialogue_state.relation.neutral)

func _make_ally(receiver: character):
	if(receiver == partner):
		pawn.dialogue.set_relation(receiver.name, 2)#dialogue_state.relation.ally)

func _become_ally(receiver: character):
	if(receiver == partner):
		receiver.dialogue.set_relation(pawn.name, 2)#dialogue_state.relation.ally)

func introduction_silent_conversation() -> Array:
	var statement_name: String = "introduction_silent"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "Hello, my name is {self}! How can I help you?",
			"effects": ["_introduce_self"],
			"responses": [
				{
					"say": "...",
					"next": "was_silent"
				},
			]
		},
		"was_silent": {
			"say": "Come back when you're willing to talk to me!",
			"effects": "_end_dialogue",
			"next": "welcome_back"
		},
		"welcome_back": {
			"say": "Welcome back! Want to speak now?",
			"responses": [
				{
					"say": "...",
					"next": "still_not"
				},
			]
		},
		"still_not": {
			"say": "Still silent? Next time, see you!",
			"effects": "_end_dialogue",
			"next": "welcome_back"
		}
	}, [statement_name])
	return [statement_name, "start"]

func unimplemented_conversation() -> Array:
	var statement_name: String = "unimplemented"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "Hey {partner}, I'm {self}. :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!",
			"effects": ["_introduce_self"],
			"responses": [
				{
					"say": "Alright, on my way!",
					"effects": "_end_dialogue"
				},
				{
					"say": "Definitely not going to do that, hate this game!",
					"effects": "_end_dialogue"
				},
				{
					"say": "Bye!",
					"effects": "_end_dialogue"
				},
			]
		}
	}, [statement_name])
	return [statement_name, "unimplemented"]

var statements: Dictionary = {}
var conversations: Dictionary = {}

func init(new_pawn: character, new_dialogue_status: Dictionary):
	pawn = new_pawn
	partners = new_dialogue_status
	conversations["unimplemented"] = unimplemented_conversation()
	init_statements()
	init_conversations()
	init_partners()

func init_statements():
	pass

func init_conversations(): # TODO? remove?
	conversations["introduction_silent"] = introduction_silent_conversation()

func init_partners():
	pass

func default_conversation() -> Array:
	return ["unimplemented", "start"]

func change_partner(new_partner: character):
	partner = new_partner

func set_response(response: statement):
	set_response_path(response.path)

func set_response_path(response_path: Array):
	partners[partner.name] = response_path

func get_statement() -> statement:
	return statement_path_to_statement(partners.get(partner.name, default_conversation()))

func statement_path_to_statement(path: Array) -> statement:
	var s = statements
	var is_response: bool = false
	for x in path:
		if(x is String):
			is_response = false
			s = s[x]
		else:
			is_response = true
			s = s.responses[x]
	if(s):
		if(is_response):
			s.update(partner, pawn)
		else:
			s.update(pawn, partner)
	return s
