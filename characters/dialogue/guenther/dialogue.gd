extends Node

# warning-ignore:unused_class_variable
static func dialogue() -> Dictionary:
	return {
		0: _introduction(),
		1: {
			"name": "???",
			"say": "Oh, sorry. I didn't notice you, was just talking to myself. I'm Günther, what did you say?",
			"answers": [
				["Just asking your name.", 2],
				["Never mind", 3],
				["Don't mind me, see you.", -1],
			]
		},
		2: {
			"say": "Well, I think I solved that problem already. See you!"
		},
		3: {
			"say": "Alright, see you!"
		}
	}

static func _introduction() -> Dictionary:
	return {
	#	0: {
			"name": "???",
			"say": "I'm dead. At the same time, I'm not. Confusing sometimes.",
			"answers": [
				["What's your name?", 1],
				["What's it like?", 1],
				["Bye!", -1],
			]
	#	}
	}
