extends Node

# warning-ignore:unused_class_variable
var options = {
	"master_volume": 1.0,
	"music_volume": 1.0,
}

func _set_bus_volume(bus_name: String, value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(value))
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), value < 0.01)

func set_options(set: Node):
	set_master_volume(set.get_setting("sound", "master_volume"))
	set_music_volume(set.get_setting("sound", "music_volume"))

func set_master_volume(value: float):
	_set_bus_volume("Master", value)

func set_music_volume(value: float):
	_set_bus_volume("Music", value)
