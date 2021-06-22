extends Spatial

onready var camera = $"spring_arm/player_camera"

# Control variables
var max_pitch : float = 45
var min_pitch : float = -45
var max_zoom : float = 20
var min_zoom : float = 4
var zoom_step : float = 2
var zoom_y_step : float = 0.15
var vertical_sensitivity : float = 0.002
var horizontal_sensitivity : float = 0.002
var camera_y_offset : float = 4.0
var camera_lerp_speed : float = 16.0

var current_zoom : float = 0.0

func _ready():
	camera.translate(Vector3(0, camera_y_offset, max_zoom))
	current_zoom = max_zoom

func _input(event):
	if(event is InputEventMouseMotion):
		# Rotate the rig around the target
		rotate_y(-event.relative.x * horizontal_sensitivity)
		rotation.x = clamp(rotation.x - event.relative.y * vertical_sensitivity, deg2rad(min_pitch), deg2rad(max_pitch))
		orthonormalize()

	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index == BUTTON_WHEEL_UP and current_zoom > min_zoom):
				current_zoom -= zoom_step
				camera_y_offset -= zoom_y_step
			if(event.button_index == BUTTON_WHEEL_DOWN and current_zoom < max_zoom):
				current_zoom += zoom_step
				camera_y_offset += zoom_y_step

func _physics_process(delta):
	pass#camera.set_translation(camera.translation.linear_interpolate(Vector3(0, camera_y_offset, current_zoom), delta * camera_lerp_speed))
