class_name abstract_dialogue

class statement:
	var text: String
	var answers: Array

	func _init(new_text: String, new_answers: Array):
		text = new_text
		answers = new_answers

	func formatted_text() -> String:
		return text.format({"self": "???", "partner": "?????"}) # todo

	func get_valid_answers() -> Array:
		var valid_answers: Array = []
		for x in answers:
			if(x.requirements_satisfied()):
				valid_answers.push_back(x)
		return valid_answers

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
	var effect: FuncRef
	var requires: int

	func _init(new_text: String, new_effect: FuncRef, new_requirements: int=requirements.ALL):
		text = new_text
		effect = new_effect
		requires = new_requirements

	func formatted_text() -> String:
		return text.format({"self": "???", "partner": "?????"}) # todo

	func requirements_satisfied() -> bool:
		return true # todo: implement answer requirements

var statements: Array
var _start_statements: Dictionary
var _inactive_partners: Dictionary
var call_names: Dictionary
var _wants_to_say_queue: Array # contains all currently valid statement indices, sorted by priority (last element highest priority)

var pawn: character
var partner: character

func _end_dialogue():
	pawn.dialogue.end_dialogue()

func stranger_greetings() -> Array:
	return [
		"Hello, stranger!",
		"A pleasure to meet you, stranger!"
	]

func friendly_greetings() -> Array:
	return [
		"Hello, my friend!",
		"Hello, {partner}!"
	]

func neutral_greetings() -> Array:
	return [
		"I greet you!"
	]

func hostile_greetings() -> Array:
	return [
		"What do you want?"
	]

func murder_witness() -> Array:
	return [
		"M U R D E R E R !"
	]

func no_time() -> Array:
	return [
		"No time, later!",
		"Later!",
		"Another time!"
	]

func init(new_pawn: character, new_dialogue_status: Dictionary):
	pawn = new_pawn
	_inactive_partners = new_dialogue_status
	statements = _create_statements()

func _create_statements() -> Array:
	# implemented in subclasses
	var all_statements: Array = []
	all_statements.append_array(stranger_greetings())
	all_statements.append_array(neutral_greetings())
	all_statements.append_array(friendly_greetings())
	all_statements.append_array(hostile_greetings())
	all_statements.append_array(no_time())
	all_statements.append_array(murder_witness())
	return all_statements

func change_partner(new_partner: character):
	if(partner):
		_inactive_partners[partner.name] = _wants_to_say_queue
	partner = new_partner
	_wants_to_say_queue = _inactive_partners[partner.name]

func call_name() -> String:
	return call_names.get(partner.name, "???")

func dialogue() -> statement:
	return statements[_wants_to_say_queue.pop_back()[1]]

func add_want_to_say(statement_index: int, priority: int):
	for i in range(_wants_to_say_queue.size()):
		if(_wants_to_say_queue[i][0] > priority):
			_wants_to_say_queue.insert(i, [priority, statement_index])
			return
	_wants_to_say_queue.push_back([priority, statement_index])

func transition(answer: answer):
	errors.debug_assert(answer.requirements_satisfied(), "requirements of answer not satisfied!")
	_inactive_partners[partner.name] = answer.effect.call_func()
