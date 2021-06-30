extends Node

# warning-ignore:unused_class_variable
static func dialogue() -> Dictionary:
	return {
		0: {
			"say": "Hey :) You actually found an unimplemented dialogue, feel free to contact the devs and help improving the game.",
			"answers": [
				["Alright, on my way!", -1],
				["Definetly not going to do this, hate the game!", -1],
				["Bye!", -1],
			]
		}
	}
