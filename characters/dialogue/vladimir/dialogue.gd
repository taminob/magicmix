extends abstract_dialogue

func init_statements():
	pass

func init_conversations():
	super.init_conversations()
	conversations["want_to_arrest"] = want_to_arrest()

func init_partners():
	partners[hans_person.id()] = conversations["want_to_arrest"]
	wants_to_talk_to.push_back(hans_person.id())

func want_to_arrest() -> Array:
	var statement_name: String = "want_to_arrest"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": _arrest_sentence(),
			"responses": [
				{
					"say": "I surrender!",
					"next": "surrendered"
				},
				{
					"say": "You'll only get me dead!",
					"effects": "_make_enemy",
					"next": "start"
				},
				{
					"say": "Who are you?",
					"next": "no_questions"
				},
				{
					"say": "Why?",
					"next": "no_questions"
				}
			]
		},
		"no_questions": {
			"say": "No questions, back to jail with you!",
			"responses": [
				{
					"say": "I surrender!",
				},
				{
					"say": "You'll only get me dead!",
					"effects": "_make_enemy",
					"next": "start"
				},
			]
		},
		"surrendered": {
			"say": "Come here, slowly. No one has to die today!",
			"responses": [
				{
					"say": "Sure",
					"effects": "_end_dialogue",
					"next": "start"
				},
				{
					"say": "Ha, tricked you! Only one of us will survive the day.",
					"effects": "_make_enemy",
					"next": "start"
				}
			]
		}
	}, [statement_name])
	return [statement_name, "start"]

func _arrest_sentence() -> String:
	return util.random_element([
		"Halt, you! You are under arrest!",
		"Stop, you are arrested!"
	])
