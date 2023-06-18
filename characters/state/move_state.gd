extends Node

class_name move_state

@onready var state: Node = get_parent()
@onready var pawn: CharacterBody3D = $"../.."
#onready var skills: Node = $"../skills" # TODO! fix cylic include, currently circumvented by pawn.skills
@onready var stats: Node = $"../stats"
@onready var dialogue: Node = $"../dialogue"

const RUN_SPEED: float = 10.0
const WALK_SPEED: float = 7.0
const SPRINT_SPEED: float = 15.0
const ACCELERATION: float = 7.0
const DE_ACCELERATION: float = 8.0
const GRAVITY: float = 9.81
const JUMP_VELOCITY: float = 5.0
const SPIRIT_RANGE_SQUARED: float = 500.0
const SPIRIT_SPEED_FACTOR: float = 2.0
const MIN_SPEED_FACTOR: float = 0.5

var gravity_direction: Vector3 = Vector3.DOWN
var velocity: Vector3 = Vector3.ZERO
var spirit_velocity: Vector3 = Vector3.ZERO
var immovable: bool = false
var frozen: bool = false
var base_speed_factor: float = 1.0

func speed_factor() -> float:
	# todo: integrate experience system
	if(state.is_spirit):
		return SPIRIT_SPEED_FACTOR
	return base_speed_factor

enum move_mode {RUNNING, WALKING, SPRINTING}
var current_mode = move_mode.RUNNING
var jump_requested: bool = false
var input_direction: Vector3 = Vector3.ZERO # unnormalized input direction
func max_speed(mode: int=current_mode) -> float:
	match mode:
		move_mode.RUNNING: return RUN_SPEED * speed_factor()
		move_mode.WALKING: return WALK_SPEED * speed_factor()
		move_mode.SPRINTING: return SPRINT_SPEED * speed_factor()
	return WALK_SPEED * speed_factor()

func stamina_cost(mode: int=current_mode) -> float:
	if(is_moving() && !state.is_spirit):
		match mode:
			move_mode.WALKING:
				return 0.0
			move_mode.RUNNING:
				return -0.8 * stats.stamina_per_second()
			move_mode.SPRINTING:
				return -1.5 * stats.stamina_per_second()
	return 0.0

func can_move() -> bool:
	return (!stats.dead || stats.undead || game.levels.current_level_data.is_in_death_realm()) && !immovable && !frozen

func set_frozen(new_frozen: bool):
	frozen = new_frozen
	if(frozen):
		dialogue.end_dialogue()

func is_moving() -> bool:
	return !input_direction.is_equal_approx(Vector3.ZERO)

func move_process(delta: float):
	if(state.is_spirit):
		_move_spirit(delta)
		move_process_dead(delta)
	else:
		_move_normal(delta)

func move_process_dead(delta: float):
	# gravity and friction even when dead
	var hv = Vector3(velocity.x, 0, velocity.z)
	hv = hv.lerp(Vector3.ZERO, DE_ACCELERATION * delta)
	velocity += gravity_direction * GRAVITY * delta
	pawn.set_velocity(Vector3(hv.x, velocity.y, hv.z))
	pawn.set_up_direction(Vector3.UP)
	pawn.set_floor_stop_on_slope_enabled(true)
	pawn.move_and_slide()
	velocity = pawn.velocity

var _move_direction: Vector3 = Vector3.ZERO
func _move_normal(delta: float):
	if(pawn.is_on_floor()):
		if(jump_requested):
			_move_direction = velocity.normalized()
			velocity.y = JUMP_VELOCITY
			jump_requested = false
		_move_direction = input_direction.rotated(Vector3.UP, pawn.rotation.y).normalized()

	var hv = Vector3(velocity.x, 0, velocity.z)
	var new_pos = _move_direction * max_speed()
	var accel = ACCELERATION if(_move_direction.dot(hv) > 0) else DE_ACCELERATION
	hv = hv.lerp(new_pos, accel * delta)

	velocity += gravity_direction * GRAVITY * delta
	pawn.set_velocity(Vector3(hv.x, velocity.y, hv.z))
	pawn.set_up_direction(Vector3.UP)
	pawn.set_floor_stop_on_slope_enabled(true)
	pawn.move_and_slide()
	velocity = pawn.velocity

func _move_spirit(delta: float):
	if(jump_requested):
		spirit_velocity = -pawn.spirit.global_transform.basis.z
		spirit_velocity *= 200
		jump_requested = false
	else:
		_move_direction = pawn.spirit.global_transform.basis * (input_direction)

	var hv: Vector3 = Vector3(spirit_velocity.x, spirit_velocity.y, spirit_velocity.z)
	var new_pos: Vector3 = _move_direction * max_speed()
	var accel: float = ACCELERATION if(_move_direction.dot(hv) > 0) else DE_ACCELERATION
	hv = hv.lerp(new_pos, accel * delta)

	if(pawn.position.distance_squared_to(pawn.spirit.position + hv * delta) > SPIRIT_RANGE_SQUARED):
		hv = Vector3.ZERO
	pawn.spirit.set_velocity(hv)
	pawn.spirit.set_up_direction(Vector3.UP)
	pawn.spirit.set_floor_stop_on_slope_enabled(true)
	pawn.spirit.move_and_slide()
	spirit_velocity = pawn.spirit.velocity # no gravity

var last_velocity: Vector3 = Vector3.ZERO
func collide_process(delta: float):
	if(state.is_spirit):
		return
	var total_accel: float = ((last_velocity - velocity) / delta).abs().dot(Vector3.ONE)
	var threshold: float = 1000.0
	if(total_accel > threshold):
		# use forumlar for free fall distance, multiply horizontal movement by 0.5
		var dmg: float = last_velocity.dot(last_velocity * Vector3(0.5, 1.0, 0.5)) / (2 * GRAVITY)
		if(!pawn.skills.is_spell_active(blood_dash_spell.id())):
			errors.debug_output(pawn.name + " - accel: " + str(total_accel) + "; pain: " + str(dmg) + "; velo: " + str(velocity) + "; last velo: " + str(last_velocity))
			stats._self_raw_damage(dmg)
		else:
			errors.debug_output("blood dash active - accel: " + str(total_accel) + "; pain: " + str(dmg))
		for i in range(pawn.get_slide_collision_count()):
			var collision: KinematicCollision3D = pawn.get_slide_collision(i)
			var target: Object = collision.collider
			if(collision.collider.has_method("damage")):
				collision.collider.damage(dmg, abstract_spell.element_type.raw, pawn)
			if(game.is_character(collision.collider.name)):
				target.move.velocity -= collision.normal * (last_velocity - velocity)
			# todo: also affect other KinematicBodies
	last_velocity = velocity

func save(state_dict: Dictionary):
	var _move_state = state_dict.get("move", {"translations": {}})
	_move_state["velocity"] = velocity
	_move_state["translations"][game.levels.current_level_data.id()] = pawn.position
	state_dict["move"] = _move_state

func init(state_dict: Dictionary):
	var _move_state = state_dict.get("move", {"translations": {}})
	velocity = _move_state.get("velocity", Vector3.ZERO)
	pawn.position = _move_state["translations"].get(game.levels.current_level_data.id(), pawn.position)
