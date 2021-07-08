extends Node

# warning-ignore:unused_class_variable
var options = {
	"show_fps": false
}

func set_options(set):
	set_show_fps(set.get_setting("graphics", "show_fps"))

func set_show_fps(_show_fps):
	#todo: implement
	pass
