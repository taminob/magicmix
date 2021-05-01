extends Node

onready var state = get_parent()
onready var stats = $"../stats"
onready var character = $"../.."

const RUN_SPEED = 10
const WALK_SPEED = 7
const SPRINT_SPEED = 15
const ACCELERATION = 7
const DE_ACCELERATION = 8
const GRAVITY = -9.81
const JUMP_VELOCITY = 5

var velocity = Vector3.ZERO

func speed_factor():
	# todo: integrate experience system
	return 1.0

enum {RUNNING, WALKING, SPRINTING}
var move_state = RUNNING
var jump_requested = false
var input_direction = Vector3.ZERO # unnormalized input direction
func max_speed():
	match move_state:
		RUNNING: return RUN_SPEED * speed_factor()
		WALKING: return WALK_SPEED * speed_factor()
		SPRINTING: return SPRINT_SPEED * speed_factor()

func can_move():
	return !stats.dead || levels.current_level_death_realm

func move(delta):
	if(jump_requested):
		velocity.y = JUMP_VELOCITY
		jump_requested = false
	var move_direction
	if(character.is_on_floor()):
		move_direction = input_direction.rotated(Vector3.UP, character.rotation.y).normalized()
	elif(character.is_on_wall()):
		move_direction = Vector3.ZERO
	else:
		move_direction = velocity.normalized()

	var hv = Vector3.ZERO
	hv = Vector3(velocity.x, 0, velocity.z)
	var new_pos = move_direction * max_speed()
	var accel = ACCELERATION if(move_direction.dot(hv) > 0) else DE_ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity.y += GRAVITY * delta
	velocity = character.move_and_slide(Vector3(hv.x, velocity.y, hv.z), Vector3.UP, true, 4, 0.25)

func move_dead(delta):
	# gravity even when dead
	velocity.y += GRAVITY * delta
	velocity = character.move_and_slide(velocity, Vector3.UP, true, 4, 0.25)

var last_speed = Vector3.ZERO
func collide(delta):
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

func save(_state):
	var _move_state = _state.get("move", {"translations": {}})
	_move_state["velocity"] = velocity
	_move_state["translations"][levels.current_level_name] = character.translation
	_state["move"] = _move_state

func init(_state):
	var _move_state = _state.get("move", {"translations": {}})
	velocity = _move_state.get("velocity", Vector3.ZERO)
	character.translation = _move_state["translations"].get(levels.current_level_name, character.translation)
