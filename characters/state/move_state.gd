extends Node

class_name move_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."
onready var stats: Node = $"../stats"

const RUN_SPEED: float = 10.0
const WALK_SPEED: float = 7.0
const SPRINT_SPEED: float = 15.0
const ACCELERATION: float = 7.0
const DE_ACCELERATION: float = 8.0
const GRAVITY: float = -9.81
const JUMP_VELOCITY: float = 5.0
const SPIRIT_RANGE_SQUARED: float = 500.0

var velocity: Vector3 = Vector3.ZERO
var spirit_velocity: Vector3 = Vector3.ZERO
var immovable: bool = false

func speed_factor() -> float:
	# todo: integrate experience system
	return 1.0 * (1.0 * (int(state.is_spirit) + 1))

enum {RUNNING, WALKING, SPRINTING}
var move_state = RUNNING
var jump_requested: bool = false
var input_direction: Vector3 = Vector3.ZERO # unnormalized input direction
func max_speed() -> float:
	match move_state:
		RUNNING: return RUN_SPEED * speed_factor()
		WALKING: return WALK_SPEED * speed_factor()
		SPRINTING: return SPRINT_SPEED * speed_factor()
	return WALK_SPEED * speed_factor()

func can_move() -> bool:
	return (!stats.dead || game.levels.current_level_death_realm) && !immovable

var _move_direction: Vector3 = Vector3.ZERO
func move_process(delta: float):
	if(state.is_spirit):
		_move_spirit(delta)
		move_process_dead(delta)
	else:
		_move_normal(delta)

func move_process_dead(delta: float):
	# gravity and friction even when dead
	var hv = Vector3(velocity.x, 0, velocity.z)
	hv = hv.linear_interpolate(Vector3.ZERO, DE_ACCELERATION * delta)
	velocity.y += GRAVITY * delta
	velocity = character.move_and_slide(Vector3(hv.x, velocity.y, hv.z), Vector3.UP, true)

func _move_normal(delta: float):
	if(jump_requested):
		_move_direction = velocity.normalized()
		velocity.y = JUMP_VELOCITY
		jump_requested = false

	if(character.is_on_floor()):
		_move_direction = input_direction.rotated(Vector3.UP, character.rotation.y).normalized()
#	elif(character.is_on_wall()):
#		_move_direction = Vector3.ZERO
#	else:
#		_move_direction = velocity.normalized()

	var hv = Vector3(velocity.x, 0, velocity.z)
	var new_pos = _move_direction * max_speed()
	var accel = ACCELERATION if(_move_direction.dot(hv) > 0) else DE_ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity.y += GRAVITY * delta
	velocity = character.move_and_slide(Vector3(hv.x, velocity.y, hv.z), Vector3.UP, true)

func _move_spirit(delta: float):
	if(jump_requested):
		spirit_velocity = character.spirit.global_transform.basis.z
		spirit_velocity *= 200
		jump_requested = false
	else:
		#_move_direction = input_direction.rotated(Vector3.UP, character.spirit.rotation.y).normalized()
		_move_direction = character.spirit.global_transform.basis.xform(input_direction)

	var hv: Vector3 = Vector3(spirit_velocity.x, spirit_velocity.y, spirit_velocity.z)
	var new_pos = _move_direction * max_speed()
	var accel = ACCELERATION if(_move_direction.dot(hv) > 0) else DE_ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)

	if(character.translation.distance_squared_to(character.spirit.translation + hv * delta) > SPIRIT_RANGE_SQUARED):
		hv = Vector3.ZERO
	#spirit_velocity = spirit.move_and_slide(Vector3(hv.x, spirit_velocity.y + GRAVITY * delta, hv.z), Vector3.UP, true)
	spirit_velocity = character.spirit.move_and_slide(hv, Vector3.UP, true) # no gravity

var last_speed: Vector3 = Vector3.ZERO
func collide_process(delta: float):
	if(state.is_spirit || stats.dead):
		return
	var d_x = abs(last_speed.x - velocity.x) / delta
	var d_y = abs(last_speed.y - velocity.y) / delta
	var d_z = abs(last_speed.z - velocity.z) / delta
	var max_axis = max(d_x, max(d_y, d_z))
	var threshold = 600
	if(max_axis > threshold):
		var dmg = pow((max_axis - threshold*0.8)/100, 2)
		errors.test("impact: " + str(max_axis) + "; dmg: " + str(dmg) + "velo: " + str(velocity) + "; last: " + str(last_speed))
		stats._self_damage(dmg)
		for i in range(character.get_slide_count()):
			var collision = character.get_slide_collision(i)
			if(collision.collider.has_method("damage")):
				collision.collider.damage(dmg)
	last_speed = velocity

func save(state_dict: Dictionary):
	var _move_state = state_dict.get("move", {"translations": {}})
	_move_state["velocity"] = velocity
	_move_state["translations"][game.levels.current_level_name] = character.translation
	state_dict["move"] = _move_state

func init(state_dict: Dictionary):
	var _move_state = state_dict.get("move", {"translations": {}})
	velocity = _move_state.get("velocity", Vector3.ZERO)
	character.translation = _move_state["translations"].get(game.levels.current_level_name, character.translation)
