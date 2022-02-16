extends Node

# warning-ignore:unused_class_variable
var options = {
	"god_mode": false,
	"everyone_has_every_skill": false,
	"console": false,

	# not visible in ui (debug settings)
	"debug_target": "",
	"start_level": "death_realm", # TODO: remove, just for debugging
	"start_character": "gerhard",
}

func set_options(set: Node):
	set_god_mode(set.get_setting("dev", "god_mode"))
	set_console(set.get_setting("dev", "console"))
	set_everyone_has_every_skill(set.get_setting("dev", "everyone_has_every_skill"))

# do nothing, settings will be read from dictionary when needed; todo? add cache
func set_god_mode(_god_mode: bool):
	pass

func set_everyone_has_every_skill(_enabled: bool):
	pass

func set_console(_enabled: bool):
	pass
