extends Node
# todo: remove on all non-player characters (?)

onready var state = get_parent()
# warning-ignore:unused_class_variable
onready var character = $"../.."
onready var move = $"../move"
onready var skills = $"../skills"
onready var interaction = $"../interaction"

func _input(event):
	if(state.is_player):
		move_input(event)
		action_input(event)

func _physics_process(delta):
	if(state.is_player):
		move_input_process(delta)

func move_input_process(_delta):
	move.input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move.input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func move_input(event):
	if(event.is_action_pressed("jump")):
		move.jump_requested = true
	if(event.is_action_pressed("sprint") && move.move_state == move.RUNNING):
		move.move_state = move.SPRINTING
	elif(event.is_action_pressed("walk") && move.move_state == move.RUNNING):
		move.move_state = move.WALKING
	elif(event.is_action_released("sprint") && move.move_state == move.SPRINTING ||
		event.is_action_released("walk") && move.move_state == move.WALKING):
		move.move_state = move.RUNNING

# todo: tbd: move camera on mouse move?
#func camera_input(event):
#	if(event is InputEventMouseMotion):
#		character.get_node("camera").position = event.position

func action_input(event):
	if(event.is_action_pressed("interact")):
		interaction.interact()
	if(event.is_action_pressed("slot0")):
		skills.cast_slot(0)
	if(event.is_action_pressed("slot1")):
		skills.cast_slot(1)
	if(event.is_action_pressed("slot2")):
		skills.cast_slot(2)
	if(event.is_action_pressed("slot3")):
		skills.cast_slot(3)
	if(event.is_action_pressed("slot4")):
		skills.cast_slot(4)