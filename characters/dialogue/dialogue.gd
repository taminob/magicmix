class_name abstract_dialogue

class statement:
	var text: String
	var effects: Array
	var answers: Array
	var speaker: character
	var receiver: character

	func _init(new_speaker: character, new_receiver: character, new_text: String, new_effects: Array=[], new_answers: Array=[]):
		speaker = new_speaker
		receiver = new_receiver
		text = new_text
		effects = new_effects
		answers = new_answers
		for x in answers:
			x.current_statement = self

	func formatted_text() -> String:
		return text.format({"self": speaker_name(), "partner": receiver_name()}) # todo

	func execute_effects(receive: character=receiver):
		for x in effects:
			x.call_func(receive)

	func get_valid_answers() -> Array:
		var valid_answers: Array = []
		for x in answers:
			if(x.requirements_satisfied()):
				valid_answers.push_back(x)
		return valid_answers

	func speaker_name() -> String:
		return speaker.dialogue.display_name

	func receiver_name() -> String:
		return speaker.dialogue.get_call_name(receiver.name)

class answer:
	enum requirements {
		relationship_enemy		= 0x0001,
		relationship_rival		= 0x0002,
		relationship_neutral	= 0x0004,
		relationship_friend		= 0x0008,
		relationship_ally		= 0x0010,

		ALL						= 0xFFFF
	}
	var text: String
	var current_statement: statement
	var next_statement: statement
	var effects: Array # array of FuncRefs
	var requires: int

	func _init(new_text: String, new_next_statement: statement, new_effects: Array=[], new_requirements: int=requirements.ALL):
		text = new_text
		next_statement = new_next_statement
		effects = new_effects
		requires = new_requirements

	func formatted_text() -> String:
		return text.format({"self": current_statement.speaker_name(), "partner": current_statement.receiver_name()}) # todo

	func next() -> statement:
		return next_statement if next_statement else current_statement

	func requirements_satisfied() -> bool:
		return true # todo: implement answer requirements

	func execute_effects():
		for x in effects:
			x.call_func()

var _start_statements: Dictionary
var _inactive_partners: Dictionary
var _wants_to_say_queue: Array # contains all currently valid statement indices, sorted by priority (last element highest priority)

var pawn: character
var partner: character

func _end_dialogue():
	pawn.dialogue.end_dialogue()

func _introduce(receiver: character=partner):
	if(receiver):
		receiver.dialogue.call_names[pawn.name] = pawn.dialogue.display_name

func _unimplemented_statement() -> statement:
	return statement.new(pawn, partner, "Hey {partner}, I'm {self}. :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!", [
		funcref(self, "_introduce")], [
		answer.new("Alright, on my way!", null, [funcref(self, "_end_dialogue")]), 
		answer.new("Definitely not going to do that, hate this game!", null, [funcref(self, "_end_dialogue")]), 
		answer.new("Bye!", null, [funcref(self, "_end_dialogue")])])

func murder_witness_statement() -> statement:
	return statement.new(pawn, partner, _murder_witness())

func _stranger_greeting() -> String:
	return util.random_element([
		"Hello, stranger!",
		"A pleasure to meet you, stranger!"
	])

func _friendly_greeting() -> String:
	return util.random_element([
		"Hello, my friend!",
		"Hello, {partner}!"
	])

func _neutral_greetings() -> String:
	return util.random_element([
		"I greet you!"
	])

func _hostile_greetings() -> String:
	return util.random_element([
		"What do you want?"
	])

func _murder_witness() -> String:
	return util.random_element([
		"M U R D E R E R !"
	])

func _long_time_not_seen() -> String:
	return util.random_element([
		"Oh, it's you - has been a long time!",
		"Where were you?"
	])

func _no_time() -> String:
	return util.random_element([
		"No time, later!",
		"Later!",
		"Another time!"
	])

func init(new_pawn: character, new_dialogue_status: Dictionary):
	pawn = new_pawn
	_inactive_partners = new_dialogue_status
	_init_statements()

func _init_statements():
	pass

func change_partner(new_partner: character):
	if(partner):
		_inactive_partners[partner.name] = _wants_to_say_queue
	partner = new_partner
	_wants_to_say_queue = _inactive_partners.get(partner.name, [])
	if(_wants_to_say_queue.empty()):
		add_want_to_say(_start_statements.get(partner.name, _unimplemented_statement()), 1)

func formatted_text(text: String) -> String:
	return text.format({"self": pawn.dialogue.display_name, "partner": pawn.dialogue.call_names[partner.name]}) # todo

func dialogue() -> statement:
	return _wants_to_say_queue.pop_back()[1]

func add_want_to_say(say: statement, priority: int):
	for i in range(_wants_to_say_queue.size()):
		if(_wants_to_say_queue[i][0] > priority):
			_wants_to_say_queue.insert(i, [priority, say])
			return
	_wants_to_say_queue.push_back([priority, say])

func transition(answer: answer):
	errors.debug_assert(answer.requirements_satisfied(), "requirements of answer not satisfied!")
	answer.execute_effects()
	add_want_to_say(answer.next(), 1)
