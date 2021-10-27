extends abstract_dialogue

func init_statements():
	pass #default_statement()

func init_conversations():
	conversations["hans_meet_first_time"] = hans_meet_first_time()

func init_partners():
	partners[hans_person.id()] = conversations["hans_meet_first_time"]

func default_conversation() -> Array:
	var statement_name: String = "default"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": dialogue_helpers._stranger_greeting() + "\nWhat's your name?",
			"answers": [
				{
					"say": "{partner}.",
					"effects": ["_introduce_partner"],
					"next": "introduced"
				},
				{
					"say": "I honestly can't remember.",
					"next": "cant_help"
				},
				{
					"say": "Sorry, can't tell you.",
					"next": "wont_tell"
				}
			]
		},
		"introduced": {
			"say": "Glad to get to know you, I'm {self}.\nUntil we meet again!",
			"effects": ["_introduce_self"],
			"answers": [
				{
					"say": "Bye!",
					"effects": ["_end_dialogue"],
					"next": "meet_again"
				}
			]
		},
		"cant_help": {
			"say": "I'm sorry to hear that, but unfortunately I don't know it either.\nJust keep asking and I'm sure you'll find out again!",
			"answers": [
				{
					"say": "See you!",
					"effects": ["_end_dialogue"],
					"next": "unknown_again"
				}
			]
		},
		"wont_tell": {
			"say": "Well, looks like you won't get my name either!\nUntil next time, stranger.",
			"answers": [
				{
					"say": "Bye!",
					"effects": ["_end_dialogue"],
					"next": "unknown_again"
				}
			]
		},
		"unknown_again": {
			"say": "Hello again, can you tell me your name now? You won't get my name otherwise either!",
			"answers": [
				{
					"say": "{partner}.",
					"effects": ["_introduce_partner"],
					"next": "introduced"
				},
				{
					"say": "Sorry, still do not know it.",
					"next": "cant_help"
				},
				{
					"say": "Sorry, can't tell you.",
					"next": "wont_tell"
				}
			]
		},
		"meet_again": {
			"say": "Nice to meet you again, {partner}!\nHow can I help you?",
			"answers": [
				{
					"say": "Nothing, see you!",
					"effects": ["_end_dialogue"]
				}
			]
		}
	}, [statement_name])
	return [statement_name, "start"]



func hans_meet_first_time() -> Array:
	var statement_name: String = "hans_meet_first_time"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "Hello, my dear, I'm Mary! You look lost, can I help you?",
			"effect": ["_introduce_self"],
			"answers": [
				{
					"say": "Where am I?",
					"next": "where"
				},
				{
					"say": "Can you help me get out of here?",
					"next": "thief"
				}
			]
		},
		"where": {
			"say": "You are in the backyard of the rainbow palace, residence of our lord! How did you get here?",
			"answers": [
				{
					"say": "Quite honestly, I have no idea!",
					"next": "leave"
				}
			]
		},
		"thief": {
			"say": "Are you a thief? How did you get in here?",
			"answers": [
				{
					"say": "No, of course not!",
					"next": "leave"
				}
			]
		},
		"leave": {
			"say": "Actually, it doesn't matter. But you should leave before the guards notice you. Hurry!",
			"answers": [
				{
					"say": "",
					"next": "final_leave"
				}
			]
		},
		"final_leave": {
			"say": "Hurry and leave!"
		}
	}, [statement_name])
	return [statement_name, "start"]
	# todo? remove alternative dialogue creation method below
#	var s: Dictionary = {}
#	s["start"] = statement.new("Hello, my dear, I'm Mary! You look lost, can I help you?", [funcref(self, "_introduce_self")])
#	s["where"] = statement.new("You are in the backyard of the rainbow palace, residence of our lord! How did you get here?")
#	s["thief"] = statement.new("Are you a thief? How did you get in here?")
#	s["leave"] = statement.new("Actually, it doesn't matter. But you should leave before the guards notice you. Hurry!")
#	s["final_leave"] = statement.new("Hurry and leave!")
#	s["start"].answers = [
#		answer.new("Where am I?", [statement_name, "where"]),
#		answer.new("Can you help me get out of here?", [statement_name, "thief"])
#	]
#	var no_idea_answer = answer.new("Quite honestly, I have no idea!", [statement_name, "leave"])
#	s["where"].answers = [
#		no_idea_answer
#	]
#	s["thief"].answers = [
#		no_idea_answer,
#		answer.new("No, of course not!", [statement_name, "leave"])
#	]
#	s["leave"].answers = [
#		answer.new("", [statement_name, "final_leave"])
#	]
#	_statements[statement_name] = s
#	return [statement_name, "start"]
