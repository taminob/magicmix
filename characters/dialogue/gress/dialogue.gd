extends abstract_dialogue

func init_statements():
	pass #default_statement()

func init_conversations():
	super.init_conversations()
	conversations["player_meet_first_time"] = player_meet_first_time()

func init_partners():
	partners[gerhard_person.id()] = conversations["player_meet_first_time"]
	wants_to_talk_to.push_back(gerhard_person.id())

func default_conversation() -> Array:
	var statement_name: String = "default"
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "How can I help you?",
			"responses": [
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
			"responses": [
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
			"responses": [
				{
					"say": "I'm {self}!",
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
			"responses": [
				{
					"say": "Where am I?",
					"next": "where"
				},
			]
		},
		"no_other_way_in": {
			"say": "I know of no other way in except dying. But it's not that bad. At least, you can't feel any pain here.",
			"responses": [
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
	statements[statement_name] = create_statements_from_dict({
		"start": {
			"say": "Ah, you're awake. So the ritual actually worked.",
			"effect": ["_introduce_self"],
			"responses": [
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
			"responses": [
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
			"responses": [
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
			"responses": [
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
			"say": "You are here to help me and save our world!",
			"responses": [
				{
					"say": "Why should I care?",
					"next": "reason_threat"
				}
			]
		},
		"reason_threat": {
			"say": "Because now you are here with us and you will be doomed as we are if our world dies.",
			"responses": [
				{
					"say": "I will find a way back.",
					"next": "no_way_back"
				}
			]
		},
		"no_way_back": {
			"say": "You won't because there is none. But good luck. But in the meantime, you can save our world and you will be rewarded with fortunes you can only dream of.",
			"responses": [
				{
					"say": "What do you want me to do?",
					"next": "task"
				}
			]
		},
		"task": {
			"say": "Enter this portal here and someone will be waiting for you. He'll ask you for his name, it's Günther.\nBe wary though, the portal will send you to the realm of the living. Meaning you can die.",
			"effects": ["_end_dialogue", "_no_more_want_to_talk_to_partner"]
		}
	}, [statement_name])
	return [statement_name, "start"]
