extends abstract_dialogue

func init_statements():
	pass

func init_conversations():
	super.init_conversations()
	pass

func init_partners():
	pass

func _begin_fight(speaker: character, receiver: character):
	if(game.mgmt.is_player(speaker) || game.mgmt.is_player(receiver)):
		game.levels.level_data["arena"].data["enemies"] = ["minion", "minion", "minion", "minion", "minion", "minion", "minion"]
		game.levels.change_level("arena")

func default_conversation() -> Array:
	var statement_name: String = "default"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "You dare to challenge me, you worm?",
			"responses": [
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
			"effects": ["_end_dialogue"],
			"next": "start",
		},
		"fight": {
			"say": "You. Will. Die.",
			"responses": [
				{
					"say": "Let's begin!",
					"effects": ["_end_dialogue", "_begin_fight"],
					"next": "start"
				}
			]
		}
	}, [statement_name])
	return [statement_name, "start"]
