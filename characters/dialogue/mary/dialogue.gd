extends Node

# warning-ignore:unused_class_variable
static func dialogue() -> Dictionary:
	return {
		0: {
			"name": "???",
			"say": "Hello, my dear! My name is Mariliry!",
			"answers": [
				["May I call you something shorter?", 1],
				["I hate you!", 3],
				["Bye!", -1]
			]
		},
		1: {
			"name": "Mariliry",
			"say": "Sure, just call me Mary!",
			"answers": [
				["Great!", 2]
			]
		},
		2: {
			"say": "See you!",
			"answers": [
				["See you!", -1]
			]
		},
		3: {
			"say": "Never again talk to me again!",
			"answers": [ ]
		}
	}
