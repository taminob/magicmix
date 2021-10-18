extends abstract_dialogue

func _init_statements():
	_start_statements["gerhard"] = player_meet_first_time()
# warning-ignore:return_value_discarded
	default_statement()

func default_statement() -> Array:
	var statement_name: String = "default"
	_statements[statement_name] = _create_statements_from_dict({
		"start": {
			"say": "How can I help you?",
			"answers": [
				{
					"say": "Where am I?",
					"next": "where"
				},
				{
					"say": "Who are you?",
					"next": "who"
				},
			]
		},
		"where": {
			"say": "Welcome to the Death Realm, looks like it's your first time here!\nBut don't worry! In the end, we all meet here.",
			"answers": [
				{
					"say": "I'm dead?",
					"next": "no_other_way_in"
				},
				{
					"say": "Who are you?",
					"next": "who"
				},
			]
		},
		"who": {
			"say": "Oh, I'm a nobody. But you may call me {self}.",
			"effects": ["_introduce_self"],
			"answers": [
				{
					"say": "I'm {partner}!",
					"effects": ["_introduce_partner"],
					"next": "nice_to_meet"
				},
				{
					"say": "Where am I?",
					"next": "where"
				},
			]
		},
		"nice_to_meet": {
			"say": "Nice to meet you, {partner}.",
			"answers": [
				{
					"say": "Where am I?",
					"next": "where"
				},
			]
		},
		"no_other_way_in": {
			"say": "I know of no other way in except dying. But it's not that bad. At least, you can't feel any pain here.",
			"answers": [
				{
					"say": "Thank you.",
					"effects": ["_end_dialogue"],
					"next": "start"
				}
			]
		},
	}, [statement_name])
	return [statement_name, "start"]

func player_meet_first_time() -> Array:
	var statement_name: String = "player_meet_first_time"
	var start = statement.new("Ah, you're awake. So the ritual actually worked.")
	var silent1 = statement.new("A silent one, I like you.")
	var ritual_explaination = statement.new("I summoned you from another world, a realm far away. You probably lost all the memories of it, but trust me, it was a horrible place.")
	var where = statement.new("You are in the Death Realm of our world.")
	var why = statement.new("You are here to help me and save our world.")
	var who = statement.new("I am just a humble servant of our world, here to guide you through difficult choices.")
	var reason_threat = statement.new("Because now you are here with us and you will be doomed as we are if our world dies.")
	var no_way_back = statement.new("You won't because there is none. But good luck. But in the meantime, you can save our world and you will be rewarded with fortunes you can only dream of.")
	var task = statement.new("Enter this portal here and there will be someone who can help you with the details on the other side.\nBe wary though, the portal will send you to the realm of the living. Meaning you can die.")

	_statements[statement_name] = _create_statements_from_dict({
		"start": {
			"say": "Ah, you're awake. So the ritual actually worked.",
			"effect": ["_introduce_self"],
			"answers": [
				{
					"say": "...",
					"next": "silent1"
				},
				{
					"say": "Where am I?",
					"next": "where"
				},
				{
					"say": "Ritual?",
					"next": "ritual_explanation"
				}
			]
		},
		"silent1": {
			"say": "A silent one, I like you.",
			"answers": [
				{
					"say": "...",
					"next": "ritual_explanation"
				},
				{
					"say": "Where am I?",
					"next": "where"
				},
				{
					"say": "Ritual?",
					"next": "ritual_explanation"
				}
			]
		},
		"ritual_explanation": {
			"say": "I summoned you from another world, a realm far away. You probably lost all the memories of it, but trust me, it was a horrible place.",
			"answers": [
				{
					"say": "...",
					"next": "why"
				},
				{
					"say": "Why?",
					"next": "why"
				}
			]
		},
		"where": {
			"say": "You are in the Death Realm of our world.",
			"answers": [
				{
					"say": "You mentioned a ritual.",
					"next": "ritual_explanation"
				},
				{
					"say": "Why?",
					"next": "why"
				}
			]
		},
		"why": {
			"say": "You are here to help me and save our world.",
			"answers": [
				{
					"say": "Why should I care?",
					"next": "reason_threat"
				},
				{
					"say": "Why?",
					"next": "why"
				}
			]
		},
		"reason_threat": {
			"say": "Because now you are here with us and you will be doomed as we are if our world dies.",
			"answers": [
				{
					"say": "I will find a way back.",
					"next": "no_way_back"
				}
			]
		},
		"no_way_back": {
			"say": "You won't because there is none. But good luck. But in the meantime, you can save our world and you will be rewarded with fortunes you can only dream of.",
			"answers": [
				{
					"say": "What do you want me to do?",
					"next": "task"
				}
			]
		},
		"task": {
			"say": "Enter this portal here and there will be someone who can help you with the details on the other side.\nBe wary though, the portal will send you to the realm of the living. Meaning you can die.",
		}
	}, [statement_name])
	return [statement_name, "start"]
