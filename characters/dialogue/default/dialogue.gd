extends Node

# warning-ignore:unused_class_variable
static func dialogue() -> Dictionary:
	return {
		0: {
			"say": "Hey :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!",
			"answers": [
				["Alright, on my way!", -1],
				["Definetly not going to do that, hate this game!", -1],
				["Bye!", -1],
			]
		}
	}
