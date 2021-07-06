extends Node

enum {SCREENMODE_WINDOW, SCREENMODE_FULLSCREEN, SCREENMODE_BORDERLESS}
# warning-ignore:unused_class_variable
var options = {
	"screen": 0,
	"mode": SCREENMODE_FULLSCREEN,
	"resolution": Vector2(1920, 1080),
	"vsync": false
}

const base_resolution = Vector2(3840, 2160)
var global_scale = 1.0

signal global_scale_changed

func set_options(settings):
	set_screen(settings.get_setting("display", "screen"))
	set_screenmode(settings.get_setting("display", "mode"))
	set_resolution(settings.get_setting("display", "resolution"))
	set_vsync(settings.get_setting("display", "vsync"))

func set_screen(screen):
	if(screen > OS.get_screen_count()):
		screen = 0
	# todo: change screen not working with maximized window and different resolutions
	OS.set_window_maximized(false)
	OS.set_window_fullscreen(false)
	OS.set_current_screen(screen)
	OS.set_window_size(OS.get_screen_size(screen))
	OS.set_window_position(OS.get_screen_position(screen))
	OS.set_current_screen(screen)
	set_screenmode(settings.get_setting("display", "mode"))

func set_screenmode(screenmode):
	OS.set_window_fullscreen(screenmode == SCREENMODE_FULLSCREEN)
	OS.set_borderless_window(screenmode == SCREENMODE_BORDERLESS)
	# todo: check maximize and size/position
	OS.set_window_maximized(screenmode == SCREENMODE_WINDOW)
	OS.center_window()
	OS.set_window_size(OS.get_screen_size())

func set_resolution(resolution):
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, resolution)
	get_viewport().set_size_override(true, resolution)
	global_scale = min(resolution.x / base_resolution.x, resolution.y / base_resolution.y)
	emit_signal("global_scale_changed")
	themes.scale_themes(global_scale)

func set_vsync(vsync_enabled):
	OS.set_use_vsync(vsync_enabled)
