class_name abstract_dialogue

class statement:
	enum requirements {
		relationship_enemy		= 0x0001,
		relationship_rival		= 0x0002,
		relationship_neutral	= 0x0004,
		relationship_friend		= 0x0008,
		relationship_ally		= 0x0010,

		ALL						= 0xFFFF
	}
	var text: String
	var effects: Array
	var speaker: character
	var receiver: character
	var requires: int
	var responses: Array
	var next_statement: Array

	func _init(new_text: String, new_effects: Array=[], new_responses: Array=[]):
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
		return true # todo: implement answer requirements

func create_statements_from_dict(statement_dict: Dictionary, path: Array) -> Dictionary:
	var new_dict: Dictionary = {}
	for x in statement_dict.keys():
		if(statement_dict[x].has("say")):
			var new_statement: statement = statement.new(statement_dict[x]["say"])
			var new_effects = statement_dict[x].get("effects", [])
			if(new_effects is String):
				new_statement.effects.push_back(funcref(self, new_effects))
			elif(new_effects is Array):
				for effect in new_effects:
					new_statement.effects.push_back(funcref(self, effect))
			elif(new_effects is FuncRef):
				new_statement.effects.push_back(new_effects)
			else:
				errors.debug_assert(false, "invalid type for new_effects")
			for response_data in statement_dict[x].get("responses", []):
				var new_response: statement = statement.new(response_data.get("say", ""))
				var new_next = response_data.get("next", path + [x])
				if(new_next is String):
					new_next = path + [new_next]
				new_response.next_statement = new_next
				for effect in response_data.get("effects", []):
					new_response.effects.push_back(funcref(self, effect))
				new_statement.responses.push_back(new_response)
			var new_next = statement_dict[x].get("next", path + [x])
			if(new_next is String):
				new_next = path + [new_next]
			new_statement.next_statement = new_next
			new_dict[x] = new_statement
		else:
			new_dict[x] = create_statements_from_dict(statement_dict[x], path + [x])
	return new_dict

var partners: Dictionary
var wants_to_talk_to: Array # TODO

var pawn: character
var partner: character

func _end_dialogue(receiver: character):
	receiver.dialogue.end_dialogue = true

func _introduce_self(receiver: character=partner):
	if(receiver):
		receiver.dialogue.call_names[pawn.name] = pawn.dialogue.display_name

func _introduce_partner(_receiver: character):
	pawn.dialogue.call_names[partner.name] = partner.dialogue.display_name

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
	statements["unimplemented"] = statement.new("Hey {partner}, I'm {self}. :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!", [
		funcref(self, "_introduce_self")], [
		statement.new("Alright, on my way!", [funcref(self, "_end_dialogue")]), 
		statement.new("Definitely not going to do that, hate this game!", [funcref(self, "_end_dialogue")]), 
		statement.new("Bye!", [funcref(self, "_end_dialogue")])])
	return ["unimplemented"]

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
	partners["gerhard"] = ["introduction_silent", "start"] # TODO: DEBUG (remove)

func default_conversation() -> Array:
	return ["unimplemented"]

func change_partner(new_partner: character):
	partner = new_partner

func set_response(response: statement):
	if(!response.next_statement.empty()):
		partners[partner.name] = response.next_statement

func get_statement() -> statement:
	return statement_path_to_statement(partners.get(partner.name, default_conversation()))

func statement_path_to_statement(path: Array) -> statement:
	var s = statements
	for x in path:
		s = s[x]
	if(s):
		s.update(pawn, partner)
	return s
