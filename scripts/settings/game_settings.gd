extends Node

# warning-ignore:unused_class_variable
var options = {
	"difficulty": 1
}

func set_options(set: Node):
	set_difficulty(set.get_setting("game", "difficulty"))

var difficulties: Array = [
	["Piece of cake!", {
		"self": {
			"max_pain": 1.5,
			"max_focus": 2.0,
			"max_stamina": 3.0,
		},
		"allies": {
			"max_pain": 2.0,
			"max_focus": 1.5,
			"max_stamina": 1.5,
		},
		"enemies": {
			"max_pain": 0.5,
			"max_focus": 0.5,
			"max_stamina": 0.8,
		}
	}],
	["Normal. Just normal.", {
		"self": {
			"max_pain": 1.0,
			"max_focus": 1.0,
			"max_stamina": 1.0,
		},
		"allies": {
			"max_pain": 1.0,
			"max_focus": 1.0,
			"max_stamina": 1.0,
		},
		"enemies": {
			"max_pain": 1.0,
			"max_focus": 1.0,
			"max_stamina": 1.0,
		}
	}],
	["Make your life more miserable.", {
		"self": {
			"max_pain": 0.25,
			"max_focus": 0.5,
			"max_stamina": 0.5,
		},
		"allies": {
			"max_pain": 1.0,
			"max_focus": 0.5,
			"max_stamina": 0.8,
		},
		"enemies": {
			"max_pain": 2.0,
			"max_focus": 3.0,
			"max_stamina": 2.0,
		}
	}],
]

func get_difficulty_multiplier(target: String, attribute: String, difficulty: int=options["difficulty"]) -> float:
	return difficulties[difficulty][1].get(target, {}).get(attribute, 1.0)

func get_difficulty_name(difficulty: int=options["difficulty"]) -> String:
	return difficulties[difficulty][0]

# do nothing, settings will be read from dictionary when needed
func set_difficulty(_difficulty: int):
	#todo: implement
	pass
