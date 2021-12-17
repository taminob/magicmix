extends Spatial

onready var camera: Camera = $"spring_arm/player_camera"
onready var spring_arm: SpringArm = $"spring_arm"

# Control variables
var max_pitch: float = deg2rad(70.0)
var min_pitch: float = deg2rad(-80.0)
var default_zoom: float = 1.0
var default_spring_length: float = -1
var max_zoom: float = 2.0
var min_zoom: float = 0.2
var zoom_step: float = 0.1
var zoom_y_step: float = 0.05
var vertical_sensitivity: float = 0.002
var horizontal_sensitivity: float = 0.002
var camera_y_offset: float = 4.0
var camera_lerp_speed: float = 2.0
var rotation_axes: Vector2 = Vector2(0, 1)

var _current_zoom: float = 1.0
var _free_rotate: bool = false
var _last_rotation: Vector3 = Vector3.ZERO

func _ready():
	camera.translate(Vector3(0, camera_y_offset, max_zoom))
	_current_zoom = default_zoom
	if(default_spring_length <= 0):
		default_spring_length = spring_arm.spring_length

func make_current():
	camera.make_current()

func update_environment():
	if(!camera):
		return
	if(!game.levels.current_level_data.is_in_death_realm()):
		camera.set_environment(preload("res://characters/player/default_environment.tres"))
	else:
		camera.set_environment(preload("res://characters/player/death_environment.tres"))

func _input(event: InputEvent):
	if(!camera.is_current()):
		return

	if(event is InputEventMouseMotion):
		# todo? add interpolation for camera rotation
		var pawn = get_parent()
		if(pawn && rotation_axes.x > 0 && !_free_rotate):
			pawn.rotation.x = clamp(pawn.rotation.x - event.relative.y * vertical_sensitivity, min_pitch, max_pitch)
		else:
			rotation.x = clamp(rotation.x - event.relative.y * vertical_sensitivity, min_pitch, max_pitch)
		if(pawn && rotation_axes.y > 0 && !_free_rotate):
			pawn.rotate_y(-event.relative.x * horizontal_sensitivity)
		else:
			rotate_y(-event.relative.x * horizontal_sensitivity)
		orthonormalize()

	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index == BUTTON_WHEEL_UP and _current_zoom > min_zoom):
				_current_zoom -= zoom_step
				camera_y_offset -= zoom_y_step
			if(event.button_index == BUTTON_WHEEL_DOWN and _current_zoom < max_zoom):
				_current_zoom += zoom_step
				camera_y_offset += zoom_y_step
			if(event.button_index == BUTTON_MIDDLE):
				_free_rotate = true
				_last_rotation = rotation
		else:
			if(event.button_index == BUTTON_MIDDLE && _free_rotate):
				_free_rotate = false
				rotation = _last_rotation

func _physics_process(delta: float):
	if(!camera.is_current()):
		return
	spring_arm.spring_length = lerp(spring_arm.spring_length, _current_zoom * default_spring_length, delta * camera_lerp_speed)
