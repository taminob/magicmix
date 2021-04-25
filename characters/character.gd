extends KinematicBody

const RUN_SPEED = 10
const WALK_SPEED = 7
const SPRINT_SPEED = 20
const ACCELERATION = 3
const DE_ACCELERATION = 5
const GRAVITY = -9.81
const JUMP_VELOCITY = 10

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

var max_pain = 100.0
var pain = 0.0
var max_focus = 100.0
var focus = max_focus
var focus_gain_per_second = clamp(90.0 - pain, 0, 10)
var dead = false
var in_death_realm = false

onready var collision = $"character_collision"
onready var mesh = $"character_mesh"

func _enter_tree():
	if(inventory.player_character == name):
		var camera = load("res://characters/player/camera.tscn").instance()
		camera.name = "camera"
		add_child(camera)
		set_script(load("res://characters/player/player.gd"))

func _ready():
	# todo: set attributes
	pass

func _physics_process(delta):
	if(can_move()):
		_collide(delta)
		_move(delta)
		_act(delta)

func can_move():
	return !dead || in_death_realm

func die():
	var material = mesh.material.duplicate()
	material.set("albedo_color", Color(0.9, 0.9, 0.2))
	mesh.material_override = material
	dead = true
	# todo: animation

func damage(dmg):
	_self_damage(dmg)

func _self_damage(dmg):
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
	#if(max_axis != 0):
	#	print(max_axis)
	if max_axis > 300:
		_self_damage(max_axis / 80)
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
