extends abstract_dialogue

func init_statements():
	pass

func init_conversations():
	conversations["first_meet_filz"] = first_meet_filz()

func init_partners():
	partners[filz_person.id()] = conversations["first_meet_filz"]
	wants_to_talk_to.push_back(filz_person.id())

func first_meet_filz() -> Array:
	var statement_name: String = "first_meet_filz"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "What is my name?",
			"responses": [
				{
					"say": "Hans",
					"next": "wrong"
				},
				{
					"say": "Günther",
					"next": "right",
					"speaker_requires": statement.requirements.is_player
				},
				{
					"say": "What are you talking about?",
					"next": "kill"
				},
				{
					"say": "I don't remember!",
					"next": "wrong"
				},
			],
		},
		"wrong": {
			"say": "You won't guess it.",
			"next": "kill"
		},
		"kill": {
			"say": "Just in case you're actually him, I'll kill you. My brother will tell you what to do.",
			"effects": ["_make_enemy", "_end_dialogue"]
		},
		"right": {
			"say": "Ah, it worked. Good, you're here.",
			"next": "instruction"
		},
		"instruction": {
			"say": "Kill the god mage. His tyranny will be the end of our world, he plans to tear down walls between realms."
		},
		"no_idea": {
			"say": "Forget "
		}
	}, [statement_name])
	return [statement_name, "start"]
