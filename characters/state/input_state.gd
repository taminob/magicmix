extends Node
# todo: remove on all non-player characters (?)

class_name input_state

onready var state: Node = get_parent()
onready var move: Node = $"../move"
onready var skills: Node = $"../skills"
onready var interaction: Node = $"../interaction"

func _input(event: InputEvent):
	if(state.is_player):
		move_input(event)
		action_input(event)

func _physics_process(delta: float):
	if(state.is_player):
		move_input_process(delta)

func move_input_process(_delta: float):
	move.input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move.input_direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func move_input(event: InputEvent):
	if(event.is_action_pressed("jump")):
		move.jump_requested = true
	# todo: refactor sprint/walk for a more intuitive behavior
	if(event.is_action_pressed("sprint") && move.current_mode == move.move_mode.RUNNING):
		move.current_mode = move.move_mode.SPRINTING
	elif(event.is_action_pressed("walk") && move.current_mode == move.move_mode.RUNNING):
		move.current_mode = move.move_mode.WALKING
	elif(event.is_action_released("sprint") && move.current_mode == move.move_mode.SPRINTING ||
		event.is_action_released("walk") && move.current_mode == move.move_mode.WALKING):
		move.current_mode = move.move_mode.RUNNING
	# todo: implement crouching
	#if(event.is_action_pressed("crouch") && move.is_crouching || 
	#	event.is_action_released("crouch") && !move.is_crouching):
	#	move.toggle_crouch()

# todo: tbd: move camera on mouse move here?
#func camera_input(event):
#	if(event is InputEventMouseMotion):
#		character.get_node("camera").position = event.position

func action_input(event: InputEvent):
	if(event.is_action_pressed("toggle_spirit")):
		interaction.toggle_spirit()
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
