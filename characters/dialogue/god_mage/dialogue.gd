extends abstract_dialogue

func _init_statements():
# warning-ignore:return_value_discarded
	default_statement()

func _begin_fight():
	game.levels.change_level("arena")

func default_statement() -> Array:
	var statement_name: String = "default"
	_statements[statement_name] = _create_statements_from_dict({
		"start": {
			"say": "You dare to challenge me, you worm?",
			"answers": [
				{
					"say": "I'm here to fight you.",
					"next": "fight"
				},
				{
					"say": "I beg for your forgiveness, my lord.",
					"next": "forgive"
				},
			]
		},
		"forgive": {
			"say": "I will forgive you. This time.",
			"answers": [
				{
					"say": "",
					"effects": ["_end_dialogue"],
					"next": "start"
				},
			]
		},
		"fight": {
			"say": "You. Will. Die.",
			"answers": [
				{
					"say": "Let's begin!",
					"effects": ["_end_dialogue", "_begin_fight"],
					"next": "start"
				}
			]
		}
	}, [statement_name])
	return [statement_name, "start"]
