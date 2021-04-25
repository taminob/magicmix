extends "res://characters/character.gd"

onready var pain_bar = $"../../../../ui/pain_bar"
onready var focus_bar = $"../../../../ui/focus_bar"
onready var debug_label = $"../../../../ui/debug_info_label"

#onready var animation_player = $AnimationPlayer
#onready var animation_tree = $AnimationTree
#onready var animation_state = animation_tree.get("parameters/playback")
onready var camera_pivot = $"camera"

func _physics_process(delta):
	#._physics_process(delta)
	_update_ui()

func _input(event):
	#var input_vector =  Vector3()
	#input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_vector.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#input_vector.y = Input.get_action_strength("jump")
	#if input_vector != Vector3.ZERO:
#		animation_tree.set("parameters/idle/blend_position", input_vector)
#		animation_tree.set("parameters/run/blend_position", input_vector)
#		animation_state.travel("run")
		#move_velocity = move_velocity.move_toward(input_vector * max_speed, acceleration * delta)
		#apply_impulse(Vector3.ZERO, input_vector * max_speed)
	#else:
#		animation_state.travel("idle")

	if(event.is_action_pressed("move_up") || event.is_action_released("move_down")):
		input_direction += Vector3.FORWARD
	if(event.is_action_pressed("move_down") || event.is_action_released("move_up")):
		input_direction += Vector3.BACK
	if(event.is_action_pressed("move_left") || event.is_action_released("move_right")):
		input_direction += Vector3.LEFT
	if(event.is_action_pressed("move_right") || event.is_action_released("move_left")):
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
	if(event.is_action_pressed("slot1")):
		cast(inventory.slots[1])
	if(event.is_action_pressed("slot2")):
		cast(inventory.slots[2])
	if(event.is_action_pressed("slot3")):
		cast(inventory.slots[3])
	if(event.is_action_pressed("slot4")):
		cast(inventory.slots[4])

func die():
	.die()
	_update_ui()
	var world = $".."
	world.remove_child(world.get_node("level"))
	var death_realm = load("res://world/death_realm/death_realm.tscn").instance()
	death_realm.name = "level"
	world.add_child(death_realm)
	in_death_realm = true

func _update_ui():
	pain_bar.set_value(pain)
	focus_bar.set_value(focus)
	debug_label.set_text(str(move_state))
