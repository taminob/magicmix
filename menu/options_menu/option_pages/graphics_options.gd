extends ScrollContainer

func _ready():
	$"layout/show_fps/show_fps_check".set_pressed(settings.get_setting("graphics", "show_fps"))

func _on_show_fps_check_toggled(button_pressed: bool):
	settings.set_setting("graphics", "show_fps", button_pressed)
	graphics_settings.set_show_fps(button_pressed)
