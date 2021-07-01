extends ScrollContainer

func _ready():
	$"layout/godmode/godmode_check".set_pressed(settings.get_setting("dev", "god_mode"))
	$"layout/console/console_check".set_pressed(settings.get_setting("dev", "console"))

func _on_godmode_check_toggled(button_pressed: bool):
	settings.set_setting("dev", "god_mode", button_pressed)
	dev_settings.set_god_mode(button_pressed)

func _on_console_check_toggled(button_pressed: bool):
	settings.set_setting("dev", "console", button_pressed)
	dev_settings.set_console(button_pressed)
