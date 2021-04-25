extends Node

const CONFIG_PATH = "res://settings.cfg" # use user:// for user directory
var _config_file = ConfigFile.new()
var _settings = {
	"game": {
		
	},
	"display": display_settings.options,
	"graphics": {
		
	},
	"dev": {
		
	}
}

func _ready():
	load_settings()
	display_settings.set_options(self)

func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])

	var error = _config_file.save(CONFIG_PATH)
	if(error != OK):
		errors.warning("unable to write settings file: %s" % error)

func load_settings():
	var error = _config_file.load(CONFIG_PATH)
	if(error != OK):
		errors.warning("unable to read settings file: %s; keeping defaults" % error)
		return

	for section in _settings.keys():
		for key in _settings[section].keys():
			_settings[section][key] = _config_file.get_value(section, key, null)

func get_setting(section, key):
	return _settings[section][key]

func set_setting(section, key, value):
	_settings[section][key] = value
