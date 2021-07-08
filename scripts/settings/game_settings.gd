extends Node

# warning-ignore:unused_class_variable
var options = {
	"difficulty": 0
}

func set_options(set: Node):
	set_difficulty(set.get_setting("game", "difficulty"))

func set_difficulty(_difficulty):
	#todo: implement
	pass
