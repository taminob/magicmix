extends Spatial

onready var camera: Camera = $"spring_arm/player_camera"
onready var spring_arm: SpringArm = $"spring_arm"

# Control variables
var max_pitch: float = 45.0
var min_pitch: float = -45.0
var default_zoom: float = 1.0
var max_zoom: float = 2.0
var min_zoom: float = 0.2
var zoom_step: float = 0.1
var zoom_y_step: float = 0.05
var vertical_sensitivity: float = 0.002
var horizontal_sensitivity: float = 0.002
var camera_y_offset: float = 4.0
var camera_lerp_speed: float = 2.0

var current_zoom: float = 1.0
var default_length: float = 7.0

func _ready():
	camera.translate(Vector3(0, camera_y_offset, max_zoom))
	current_zoom = default_zoom
	default_length = spring_arm.spring_length

func _input(event: InputEvent):
	if(event is InputEventMouseMotion):
		# Rotate the rig around the target
		#rotate_y(-event.relative.x * horizontal_sensitivity)
		var character = get_parent()
		if(character):
			character.rotate_y(-event.relative.x * horizontal_sensitivity)
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

func _physics_process(delta: float):
	#camera.set_translation(camera.translation.linear_interpolate(Vector3(0, camera_y_offset, current_zoom), delta * camera_lerp_speed))
	spring_arm.spring_length = lerp(spring_arm.spring_length, current_zoom * default_length, delta * camera_lerp_speed)
