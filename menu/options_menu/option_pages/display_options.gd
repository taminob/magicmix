extends ScrollContainer

var resolution_options = [Vector2(3840, 2160), Vector2(3000, 2000), Vector2(2560, 1440), Vector2(1920, 1080), Vector2(1280, 720)]

func _ready():
	init_screen_selection()
	init_screenmode_selection()
	init_resolution_selection()
	$"layout/vsync".set_pressed(settings.get_setting("display", "vsync"))

func init_screen_selection():
	var screen_choice = $layout/screen_option/screen_choice
	for i in range(OS.get_screen_count()):
		screen_choice.add_item(str(i) + ": " + str(OS.get_screen_size(i)), i)
	screen_choice.selected = settings.get_setting("display", "screen")

func init_screenmode_selection():
	var mode_choice = $"layout/screen-mode_option/screen-mode_choice"
	mode_choice.add_item("Window", 0)
	mode_choice.add_item("Fullscreen", 1)
	mode_choice.add_item("Borderless", 2)
	mode_choice.selected = settings.get_setting("display", "mode")

func init_resolution_selection():
	var res_choice = $"layout/resolution_option/resolution_choice"
	for i in range(resolution_options.size()):
		res_choice.add_item(str(resolution_options[i].x) + "x" + str(resolution_options[i].y), i)
	res_choice.selected = resolution_options.find(settings.get_setting("display", "resolution"))

func _on_screen_choice_item_selected(index):
	settings.set_setting("display", "screen", index)
	display_settings.set_screen(index)

func _on_screenmode_choice_item_selected(index):
	settings.set_setting("display", "mode", index)
	display_settings.set_screenmode(index)

func _on_resolution_choice_item_selected(index):
	settings.set_setting("display", "resolution", resolution_options[index])
	display_settings.set_resolution(resolution_options[index])

func _on_vsync_toggled(button_pressed):
	settings.set_setting("display", "vsync", button_pressed)
	display_settings.set_vsync(button_pressed)
