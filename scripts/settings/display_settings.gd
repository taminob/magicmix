extends Node

enum {SCREENMODE_WINDOW, SCREENMODE_FULLSCREEN, SCREENMODE_BORDERLESS}
# warning-ignore:unused_class_variable
var options = {
	"screen": 0,
	"mode": SCREENMODE_FULLSCREEN,
	"resolution": Vector2(1920, 1080),
	"vsync": true
}

const base_resolution = Vector2(3840, 2160)
var global_scale = 1.0

signal global_scale_changed

func set_options(set: Node):
	set_screen(set.get_setting("display", "screen"))
	set_screenmode(set.get_setting("display", "mode"))
	set_resolution(set.get_setting("display", "resolution"))
	set_vsync(set.get_setting("display", "vsync"))

func set_screen(screen: int):
	if(screen > DisplayServer.get_screen_count()):
		screen = 0
	# todo: change screen not working with maximized window and different resolutions
	get_window().mode = Window.MODE_MAXIMIZED if (false) else Window.MODE_WINDOWED
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
	get_window().set_current_screen(screen)
	get_window().set_size(DisplayServer.screen_get_size(screen))
	get_window().set_position(DisplayServer.screen_get_position(screen))
	get_window().set_current_screen(screen)
	set_screenmode(settings.get_setting("display", "mode"))

func set_screenmode(screenmode: int):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (screenmode == SCREENMODE_FULLSCREEN) else Window.MODE_WINDOWED
	get_window().borderless = (screenmode == SCREENMODE_BORDERLESS)
	# todo: check maximize and size/position
	get_window().mode = Window.MODE_MAXIMIZED if (screenmode == SCREENMODE_WINDOW) else Window.MODE_WINDOWED
	OS.center_window()
	get_window().set_size(DisplayServer.screen_get_size())

func set_resolution(resolution: Vector2):
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, resolution)
	get_viewport().set_size_2d_override(true, resolution)
	global_scale = min(resolution.x / base_resolution.x, resolution.y / base_resolution.y)
	emit_signal("global_scale_changed")
	themes.scale_themes(global_scale)

func set_vsync(vsync_enabled: bool):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (vsync_enabled) else DisplayServer.VSYNC_DISABLED)
