extends Node

const RUN_SPEED = 10
const WALK_SPEED = 7
const SPRINT_SPEED = 15
const ACCELERATION = 7
const DE_ACCELERATION = 8
const GRAVITY = -9.81
const JUMP_VELOCITY = 5

enum {RUNNING, WALKING, SPRINTING}
var move_dict = {
	RUNNING: RUN_SPEED,
	WALKING: WALK_SPEED,
	SPRINTING: SPRINT_SPEED
}

var _stats = characters.get_character(self.name)

func max_pain():
	return _stats["experience"]["sturdiness"] * 100.0

func max_focus():
	return _stats["experience"][""]

var move_state = RUNNING
var jump_requested = false
var velocity = Vector3.ZERO
var input_direction = Vector3.ZERO # unnormalized input direction

var max_pain = 100.0
var pain = 0.0
var max_focus = 100.0
var focus = 0.0
var active_spells = [[0, 0]]
var dead = false
var undead = false
var in_death_realm = false
var is_player = false

var interact_target = null
var is_in_dialog = []
