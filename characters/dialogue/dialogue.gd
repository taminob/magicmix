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

	func _init(new_text: String, new_effects: Array=[]):
		text = new_text
		effects = new_effects
		update(null, null)

	func update(new_speaker: character, new_receiver: character):
		speaker = new_speaker
		receiver = new_receiver

	func formatted_text() -> String:
		return text.format({"self": speaker_name(), "partner": receiver_name()}) # todo

	func execute_effects(receiv: character=receiver):
		for x in effects:
			x.call_func(receiv)

	func speaker_name() -> String:
		return speaker.dialogue.display_name

	func receiver_name() -> String:
		return speaker.dialogue.get_call_name(receiver.name)

	func is_valid() -> bool:
		return true # todo: implement answer requirements

var partners: Dictionary
var wants_to_talk_to: Array

var pawn: character
var partner: character

func _end_dialogue():
	pawn.dialogue.end_dialogue()

func _introduce_self(receiver: character=partner):
	if(receiver):
		receiver.dialogue.call_names[pawn.name] = pawn.dialogue.display_name

func _introduce_partner():
	pawn.dialogue.call_names[partner.name] = partner.dialogue.display_name

var default_statement_texts: Dictionary = {
	"silent": "...",
	"greeting_introduction": ["Hello, my name is {self}! How can I help you?", funcref(self, "_introduce_self")],
	"come_back_silent": ["Come back when you're willing to talk to me!", funcref(self, "_end_dialogue")],
	"welcome_back_speak_now": "Welcome back! Want to speak now?",
	"still_not": ["Still silent? Next time, see you!", funcref(self, "_end_dialogue")],
}
var silent_introduction_conversation: Dictionary = {
	"start": "greeting_introduction",
	"greeting_introduction": ["silent"],
	"silent": ["come_back_silent"],
	"come_back_silent": ["welcome_back_speak_now"],
	"welcome_back_speak_now": ["silent@"],
	"silent@": ["still_not"],
	"still_not": ["welcome_back_speak_now"]
}

var unimplemented_texts: Dictionary = {
	"on_my_way": ["On my way!", funcref(self, "_end_dialogue")],
	"unimplemented": ["Hey {partner}, I'm {self}. :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!", funcref(self, "_introduce_self")],
	"unimplemented_hate": ["Definitely not going to do that, hate this game!", funcref(self, "_end_dialogue")],
	"bye": ["Bye!", funcref(self, "_end_dialogue")],
}
var unimplemented_conversation: Dictionary = {
	"start": "unimplemented",
	"unimplemented": ["on_my_way", "unimplemented_hate", "bye"],
	"on_my_way": ["unimplmeneted"],
	"unimplemented_hate": ["unimplmeneted"],
	"bye": ["unimplmeneted"],
}

var statements: Dictionary = {}
var conversations: Dictionary = {}

func create_statements(dict: Dictionary):
	for x in dict.keys():
		if(dict[x] is Dictionary):
			create_statements(dict[x])
		elif(dict[x] is String):
			statements[x] = statement.new(dict[x])
		elif(dict[x] is Array && !dict[x].empty()):
			statements[x] = statement.new(dict[x][0], dict[x].slice(1, dict[x].size()))
		else:
			errors.debug_assert(false, "dict contains invalid type")

func init(new_pawn: character, new_dialogue_status: Dictionary):
	pawn = new_pawn
	partners = new_dialogue_status
	create_statements(unimplemented_texts) # todo? unimplemented conversation for everyone?
	conversations["unimplemented"] = unimplemented_conversation
	init_statements()

func init_statements():
	create_statements(default_statement_texts)

func init_conversations():
	conversations["silent_introduction"] = silent_introduction_conversation

func init_partners():
	partners["gress"] = "silent_introduction" # TODO: DEBUG

func default_conversation() -> String:
	return "unimplemented"

func change_partner(new_partner: character):
	partner = new_partner

func get_statement(statement_id: String) -> statement:
	var marker: int = statement_id.find("@")
	if(marker < 0):
		return statements[statement_id]
	else:
		return statements[statement_id.left(marker)]

func get_responses(statement_id: String) -> Array:
	return get_conversation()[statement_id]

func get_conversation_id() -> String:
	return partners.get(partner.name, default_conversation())

func get_conversation() -> Dictionary:
	return conversations[get_conversation_id()]
