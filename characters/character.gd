extends KinematicBody

const RUN_SPEED = 10
const WALK_SPEED = 7
const SPRINT_SPEED = 15
const ACCELERATION = 3
const DE_ACCELERATION = 5
const GRAVITY = -9.81
const JUMP_VELOCITY = 6

enum {RUNNING, WALKING, SPRINTING}
var move_dict = {
	RUNNING: RUN_SPEED,
	WALKING: WALK_SPEED,
	SPRINTING: SPRINT_SPEED
}
var move_state = RUNNING
var jump_requested = false
var velocity = Vector3.ZERO
var input_direction = Vector3.ZERO # unnormalized input direction

export(float) var max_pain = 100.0
var pain = 0.0
export(float) var max_focus = 100.0
var focus = max_focus
var focus_gain_per_second = clamp(90.0 - pain, 0, 10)
var dead = false
var in_death_realm = false
var is_player = false

onready var collision = $"character_collision"
onready var mesh = $"character_mesh"

onready var pain_bar = $"../../../../../ui/pain_bar"
onready var focus_bar = $"../../../../../ui/focus_bar"
onready var debug_label = $"../../../../../ui/debug_info_label"

#onready var camera_pivot = $"camera_pivot"

func _ready():
	# todo: set attributes
	pass

func _physics_process(delta):
	if(can_move() || in_death_realm):
		_collide(delta)
		_move(delta)
		_act(delta)
	if(is_player):
		_update_ui()

func can_move():
	return !dead || in_death_realm

func die():
	if(dead):
		return
	var material = mesh.material.duplicate()
	material.set("albedo_color", Color(0.9, 0.9, 0.2))
	mesh.material_override = material
	dead = true
	# todo: animation
	if(is_player):
		_update_ui()
		management.change_level(load("res://world/death_realm/death_realm.tscn").instance())
		in_death_realm = true

func damage(dmg):
	_self_damage(dmg)

func _self_damage(dmg):
	if(settings.get_setting("dev", "god_mode")):
		return
	pain += dmg
	pain = 0 if(pain < 0) else pain
	if(pain >= max_pain):
		die()

func cast(spell):
	if(focus < spells.spells[spell]["focus"]):
		return
	focus += spells.spells[spell]["focus"]
	_self_damage(-spells.spells[spell]["health"])
	#todo: animation

func _act(delta):
	focus = clamp(focus + focus_gain_per_second * delta, 0, max_focus)

var last_speed = Vector3.ZERO
func _collide(delta):
	#for i in range(get_slide_count()):
	#	var collision = get_slide_collision(i)
	var d_x = abs(last_speed.x - velocity.x) / delta
	var d_y = abs(last_speed.y - velocity.y) / delta
	var d_z = abs(last_speed.z - velocity.z) / delta
	var max_axis = max(d_x, max(d_y, d_z))
	if(max_axis > 300):
		print(max_axis)
	var threshold = 600
	if(max_axis > threshold):
		_self_damage(pow((max_axis - threshold)/100, 3))
	last_speed = velocity

func _move(delta):
	if(jump_requested):
		velocity.y = JUMP_VELOCITY
		jump_requested = false
	var move_direction = input_direction.rotated(Vector3.UP, rotation.y).normalized()

	var hv = Vector3(velocity.x, 0, velocity.z)

	var max_speed = move_dict[move_state]
	var new_pos = move_direction * max_speed
	var accel = ACCELERATION if(move_direction.dot(hv) > 0) else DE_ACCELERATION

	# todo: check if multiplication with delta is correct
	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity = move_and_slide(Vector3(hv.x, velocity.y + GRAVITY * 2 * delta, hv.z), Vector3.UP, true, 4, 0.25)

func _input(event):
	if(!is_player):
		return
	if(event.is_action_pressed("move_up") || (event.is_action_released("move_down") && input_direction.z != 0)):
		input_direction += Vector3.FORWARD
	if(event.is_action_pressed("move_down") || (event.is_action_released("move_up") && input_direction.z != 0)):
		input_direction += Vector3.BACK
	if(event.is_action_pressed("move_left") || (event.is_action_released("move_right") && input_direction.x != 0)):
		input_direction += Vector3.LEFT
	if(event.is_action_pressed("move_right") || (event.is_action_released("move_left") && input_direction.x != 0)):
		input_direction += Vector3.RIGHT
	if(is_on_floor() && event.is_action_pressed("jump")):
		jump_requested = true
	if(event.is_action_pressed("sprint") && move_state == RUNNING):
		move_state = SPRINTING
	elif(event.is_action_pressed("walk") && move_state == RUNNING):
		move_state = WALKING
	elif(event.is_action_released("sprint") && move_state == SPRINTING ||
		event.is_action_released("walk") && move_state == WALKING):
		move_state = RUNNING

	if(event.is_action_pressed("rotate_camera_left")):
		rotation_degrees.y += 30
	if(event.is_action_pressed("rotate_camera_right")):
		rotation_degrees.y -= 30

	if(event.is_action_pressed("interact")):
		cast("heal")
	if(event.is_action_pressed("slot0")):
		cast(inventory.slots[0])
	if(event.is_action_pressed("slot1")):
		cast(inventory.slots[1])
	if(event.is_action_pressed("slot2")):
		cast(inventory.slots[2])
	if(event.is_action_pressed("slot3")):
		cast(inventory.slots[3])
	if(event.is_action_pressed("slot4")):
		cast(inventory.slots[4])

func _update_ui():
	if(pain_bar):
		pain_bar.set_value(pain)
	if(focus_bar):
		focus_bar.set_value(focus)
	if(debug_label):
		debug_label.set_text(str(input_direction))
