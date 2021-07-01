extends Node

# warning-ignore:unused_class_variable
var options = {
	"god_mode": false,
	"console": false
}

func set_options(settings):
	set_god_mode(settings.get_setting("dev", "god_mode"))


# do nothing, settings will be read from dictionary when needed; todo? add cache
func set_god_mode(_god_mode: bool):
	pass

func set_console(_enabled: bool):
	pass
