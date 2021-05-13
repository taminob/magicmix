extends Node

onready var stats = $"../stats"
onready var character = $"../.."

const RUN_SPEED = 1000
const WALK_SPEED = 700
const SPRINT_SPEED = 1500
const ACCELERATION = 7
const DE_ACCELERATION = 8
const GRAVITY = -1600
const JUMP_VELOCITY = 300

var velocity = Vector2.ZERO

func speed_factor():
	# todo: integrate experience system
	return 1.0

enum {RUNNING, WALKING, SPRINTING}
var move_state = RUNNING
var jump_requested = false
var input_direction = Vector2.ZERO # unnormalized input direction
func max_speed():
	match move_state:
		RUNNING: return RUN_SPEED * speed_factor()
		WALKING: return WALK_SPEED * speed_factor()
		SPRINTING: return SPRINT_SPEED * speed_factor()

func can_move():
	return !stats.dead || game.levels.current_level_death_realm

# todo: improve jump mechanic (disable collision, change constants, improve on_floor check)
var z_axis = 0
onready var start_jump_y = character.position.y
var is_jumping = false
func move_process(delta):
	if(jump_requested && !is_jumping):
		z_axis = JUMP_VELOCITY
		jump_requested = false
		start_jump_y = character.position.y
		is_jumping = true
	elif(is_jumping):
		if(character.position.y < start_jump_y):
			z_axis = z_axis + GRAVITY * delta
		else:
			velocity.y = 0
			is_jumping = false
			z_axis = 0
	var move_direction = input_direction.normalized()
	# todo: animation interpolation
	if(input_direction.x > 0):
		character.sprite.set_frame(0)
	elif(input_direction.x < 0):
		character.sprite.set_frame(1)
	elif(input_direction.y > 0):
		character.sprite.set_frame(2)
	elif(input_direction.y < 0):
		character.sprite.set_frame(3)
#	if(character.is_on_floor()):
#		move_direction = input_direction.rotated(character.rotation.y).normalized()
#	elif(character.is_on_wall()):
#		move_direction = Vector2.ZERO
#	else:
#		move_direction = velocity.normalized()

	var hv = Vector2(velocity.x, velocity.y)
	var new_pos = Vector2(move_direction.x, move_direction.y) * max_speed()
	var accel = ACCELERATION if(Vector2(move_direction.x, move_direction.y).dot(hv) > 0) else DE_ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity = character.move_and_slide(Vector2(hv.x, hv.y - z_axis), Vector2.UP, true, 4, 0.25)

func move_dead(_delta):
	# gravity even when dead
	#velocity.y += GRAVITY * delta
	velocity = character.move_and_slide(Vector2(velocity.x, velocity.y), Vector2.UP, true, 4, 0.25)

var last_speed = Vector2.ZERO
func collide(delta):
	var d_x = abs(last_speed.x - velocity.x) / delta
	var d_y = abs(last_speed.y - velocity.y) / delta
	#var d_z = abs(last_speed.z - velocity.z) / delta
	var max_axis = max(d_x, d_y)
	var threshold = 90000
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
	_move_state["translations"][game.levels.current_level_name] = character.position
	_state["move"] = _move_state

func init(_state):
	var _move_state = _state.get("move", {"translations": {}})
	velocity = _move_state.get("velocity", Vector3.ZERO)
	character.position = _move_state["translations"].get(game.levels.current_level_name, character.position)
