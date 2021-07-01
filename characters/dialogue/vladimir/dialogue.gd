extends Node

# warning-ignore:unused_class_variable
static func dialogue() -> Dictionary:
	return {
		0: {
			"name": "???",
			"say": "Halt, you! Arrest him!",
			"answers": [
				["I surrender!", 2],
				["You'll only get me dead!!", -1],
				["Who are you?", 1],
				["Why?", 1]
			]
		},
		1: {
			"name": "???",
			"say": "No questions, back to jail with you!",
			"answers": [
				["I surrender!", 2],
				["You'll only get me dead!!", -1],
			]
		},
		2: {
			"name": "???",
			"say": "Come here, slowly. No one has to die today!",
			"answers": [
				["Sure", -1],
				["Ha, tricked you! Only one of us will survive the day.", -1]
			]
		}
	}
