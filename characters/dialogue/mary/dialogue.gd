extends abstract_dialogue

func init_statements():
	pass #default_statement()

func init_conversations():
	super.init_conversations()
	conversations["hans_meet_first_time"] = hans_meet_first_time()

func init_partners():
	partners[hans_person.id()] = conversations["hans_meet_first_time"]

func default_conversation() -> Array:
	var statement_name: String = "default"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": dialogue_helpers.stranger_greeting() + "\nWhat's your name?",
			"responses": [
				{
					"say": "{self}.",
					"effects": ["_introduce_self"],
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
			"responses": [
				{
					"say": "Bye!",
					"effects": ["_end_dialogue"],
					"next": "meet_again"
				}
			]
		},
		"cant_help": {
			"say": "I'm sorry to hear that, but unfortunately I don't know it either.\nJust keep asking and I'm sure you'll find out again!",
			"responses": [
				{
					"say": "See you!",
					"effects": ["_end_dialogue"],
					"next": "unknown_again"
				}
			]
		},
		"wont_tell": {
			"say": "Well, looks like you won't get my name either!\nUntil next time, stranger.",
			"responses": [
				{
					"say": "Bye!",
					"effects": ["_end_dialogue"],
					"next": "unknown_again"
				}
			]
		},
		"unknown_again": {
			"say": "Hello again, can you tell me your name now? You won't get my name otherwise either!",
			"responses": [
				{
					"say": "{self}.",
					"effects": ["_introduce_self"],
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
			"responses": [
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
			"responses": [
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
			"responses": [
				{
					"say": "Quite honestly, I have no idea!",
					"next": "leave"
				}
			]
		},
		"thief": {
			"say": "Are you a thief? How did you get in here?",
			"responses": [
				{
					"say": "No, of course not!",
					"next": "leave"
				}
			]
		},
		"leave": {
			"say": "Actually, it doesn't matter. But you should leave before the guards notice you. Hurry!",
			"responses": [
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
