extends ScrollContainer

func _ready():
	$"layout/godmode/godmode_check".set_pressed(settings.get_setting("dev", "god_mode"))

func _on_godmode_check_toggled(button_pressed):
	settings.set_setting("dev", "god_mode", button_pressed)
	dev_settings.set_god_mode(button_pressed)
