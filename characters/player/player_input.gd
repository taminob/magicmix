extends Node

static func move(target, event):
	var move_state = target.move
	if(event.is_action_pressed("move_up") || (event.is_action_released("move_down") && move_state.input_direction.y != 0)):
		move_state.input_direction += Vector2.UP
	if(event.is_action_pressed("move_down") || (event.is_action_released("move_up") && move_state.input_direction.y != 0)):
		move_state.input_direction += Vector2.DOWN
	if(event.is_action_pressed("move_left") || (event.is_action_released("move_right") && move_state.input_direction.x != 0)):
		move_state.input_direction += Vector2.LEFT
	if(event.is_action_pressed("move_right") || (event.is_action_released("move_left") && move_state.input_direction.x != 0)):
		move_state.input_direction += Vector2.RIGHT
	if(target.is_on_floor() && event.is_action_pressed("jump")):
		move_state.jump_requested = true
	if(event.is_action_pressed("sprint") && move_state.move_state == move_state.RUNNING):
		move_state.move_state = move_state.SPRINTING
	elif(event.is_action_pressed("walk") && move_state.move_state == move_state.RUNNING):
		move_state.move_state = move_state.WALKING
	elif(event.is_action_released("sprint") && move_state.move_state == move_state.SPRINTING ||
		event.is_action_released("walk") && move_state.move_state == move_state.WALKING):
		move_state.move_state = move_state.RUNNING

static func camera_move(target, event):
	return
	if(event is InputEventMouseMotion):
		target.rotate_y(-event.relative.x * 0.002)

	if(event.is_action_pressed("rotate_camera_left")):
		target.rotate_y(30)
	if(event.is_action_pressed("rotate_camera_right")):
		target.rotate_y(-30)

static func action(target, event):
	var skills_state = target.skills
	if(event.is_action_pressed("interact") && target.interact_target):
		target.interact_target.interact(target)
	if(event.is_action_pressed("slot0")):
		skills_state.cast(target.inventory.get_skill_slot(0))
	if(event.is_action_pressed("slot1")):
		skills_state.cast(target.inventory.get_skill_slot(1))
	if(event.is_action_pressed("slot2")):
		skills_state.cast(target.inventory.get_skill_slot(2))
	if(event.is_action_pressed("slot3")):
		skills_state.cast(target.inventory.get_skill_slot(3))
	if(event.is_action_pressed("slot4")):
		skills_state.cast(target.inventory.get_skill_slot(4))
