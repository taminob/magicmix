extends Node

static func move(target, event):
	if(event.is_action_pressed("move_up") || (event.is_action_released("move_down") && target.stats.input_direction.z != 0)):
		target.stats.input_direction += Vector3.FORWARD
	if(event.is_action_pressed("move_down") || (event.is_action_released("move_up") && target.stats.input_direction.z != 0)):
		target.stats.input_direction += Vector3.BACK
	if(event.is_action_pressed("move_left") || (event.is_action_released("move_right") && target.stats.input_direction.x != 0)):
		target.stats.input_direction += Vector3.LEFT
	if(event.is_action_pressed("move_right") || (event.is_action_released("move_left") && target.stats.input_direction.x != 0)):
		target.stats.input_direction += Vector3.RIGHT
	if(target.is_on_floor() && event.is_action_pressed("jump")):
		target.stats.jump_requested = true
	if(event.is_action_pressed("sprint") && target.stats.move_state == target.stats.RUNNING):
		target.stats.move_state = target.stats.SPRINTING
	elif(event.is_action_pressed("walk") && target.stats.move_state == target.stats.RUNNING):
		target.stats.move_state = target.stats.WALKING
	elif(event.is_action_released("sprint") && target.stats.move_state == target.stats.SPRINTING ||
		event.is_action_released("walk") && target.stats.move_state == target.stats.WALKING):
		target.stats.move_state = target.stats.RUNNING

static func camera_move(target, event):
	if(event is InputEventMouseMotion):
		target.rotate_y(-event.relative.x * 0.002)

	if(event.is_action_pressed("rotate_camera_left")):
		target.rotate_y(30)
	if(event.is_action_pressed("rotate_camera_right")):
		target.rotate_y(-30)

static func action(target, event):
	if(event.is_action_pressed("interact") && target.stats.interact_target):
		target.stats.interact_target.interact(target)
	if(event.is_action_pressed("slot0")):
		target.cast(inventory.get_action_slot(0))
	if(event.is_action_pressed("slot1")):
		target.cast(inventory.get_action_slot(1))
	if(event.is_action_pressed("slot2")):
		target.cast(inventory.get_action_slot(2))
	if(event.is_action_pressed("slot3")):
		target.cast(inventory.get_action_slot(3))
	if(event.is_action_pressed("slot4")):
		target.cast(inventory.get_action_slot(4))
