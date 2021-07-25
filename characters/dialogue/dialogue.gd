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
	var next_statement: int
	var effect: FuncRef
	var requires: int

	func _init(new_text: String, new_next_statement: int, new_effect: FuncRef=null, new_requirements: int=requirements.ALL):
		text = new_text
		next_statement = new_next_statement
		effect = new_effect
		requires = new_requirements

	func formatted_text() -> String:
		return text.format({"self": "???", "partner": "?????"}) # todo

	func requirements_satisfied() -> bool:
		return true # todo: implement answer requirements

var statements: Array
var _start_statements: Dictionary
var _current_statement: Dictionary

var pawn: character
var partner: character

func _end_dialogue():
	pawn.dialogue.end_dialogue()

func init(new_pawn: character, new_current_statement: Dictionary={}):
	pawn = new_pawn
	_current_statement = new_current_statement
	_init_statements()

func _init_statements():
	pass # implemented in subclasses

func change_partner(new_partner: character):
	partner = new_partner
	if(!_current_statement.has(partner.name)):
		_current_statement[partner.name] = _start_statements.get(partner.name, 0)

func call_name() -> String:
	return pawn.dialogue.display_name # todo

func dialogue() -> statement:
	return statements[_current_statement[partner.name]]

func transition(answer: answer):
	errors.debug_assert(answer.requirements_satisfied(), "requirements of answer not satisfied!")
	if(answer.effect):
		answer.effect.call_func()
	_current_statement[partner.name] = answer.next_statement
