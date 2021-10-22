extends Node
# todo: remove on all non-player characters (?)

class_name input_state

onready var state: Node = get_parent()
onready var move: Node = $"../move"
onready var skills: Node = $"../skills"
onready var interaction: Node = $"../interaction"
onready var dialogue: Node = $"../dialogue"

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

func action_input(event: InputEvent):
	if(event.is_action_pressed("toggle_spirit")):
		interaction.toggle_spirit()
	if(event.is_action_pressed("interact")):
		interaction.initiate_interact()
	if(event.is_action_pressed("ui_accept")):
		dialogue.choose_statement([]) # TODO: not working for listening
	if(event.is_action_pressed("skill0")):
		skills.cast_spell_slot(0)
		#skills.activate_skill_slot(0)
	if(event.is_action_pressed("skill1")):
		skills.cast_spell_slot(1)
		#skills.activate_skill_slot(1)
	if(event.is_action_pressed("skill2")):
		skills.cast_spell_slot(2)
		#skills.rotate_element()
	if(event.is_action_pressed("skill3")):
		skills.cast_spell_slot(3)
	if(event.is_action_pressed("skill4")):
		skills.cast_spell_slot(4)
	if(event.is_action_pressed("slot0")):
		skills.set_element(abstract_spell.element_type.life)
	if(event.is_action_pressed("slot1")):
		skills.set_element(abstract_spell.element_type.fire)
	if(event.is_action_pressed("slot2")):
		skills.set_element(abstract_spell.element_type.ice)
	if(event.is_action_pressed("slot3")):
		skills.set_element(abstract_spell.element_type.darkness)
	if(event.is_action_pressed("slot4")):
		pass
		#skills.cast_spell_slot(4)
