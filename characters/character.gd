extends KinematicBody

#onready var collision = $"character_collision"
onready var mesh = $"character_mesh"
onready var health_bar = $"health_bar"

onready var ui = $"../../../../../ui"

onready var stats = $"stats"

#onready var camera_pivot = $"camera_pivot"

func _ready():
	# todo: set attributes
	pass

func _physics_process(delta):
	if(can_move() || stats.in_death_realm):
		_collide(delta)
		_move(delta)
		_act(delta)
		_dialogue(delta)
		_update_ui()
	else:
		# gravity even when dead
		stats.velocity.y += stats.GRAVITY * delta
		stats.velocity = move_and_slide(stats.velocity, Vector3.UP, true, 4, 0.25)

func can_move():
	return !stats.dead || stats.in_death_realm

func die():
	var material = mesh.material.duplicate()
	material.set("albedo_color", Color(0.9, 0.9, 0.2))
	mesh.material_override = material
	cancel_spell()
	stats.dead = true
	# todo: animation
	if(stats.is_player && !stats.in_death_realm):
		_update_ui()
		levels.change_level("death_realm")
		stats.in_death_realm = true

func damage(dmg):
	_self_damage(dmg)

func _self_damage(dmg):
	if(settings.get_setting("dev", "god_mode") || stats.in_death_realm):
		return
	stats.pain = clamp(stats.pain + dmg, 0, stats.max_pain)
	if(stats.pain >= stats.max_pain):
		die()

func cast(spell_id):
	var spell = spells.get_spell(spell_id)
	var spell_focus = spells.get_focus(spell, "self")
	var focus_per_second = spells.get_focus(spell, "self", true)
	if(stats.focus + spell_focus < 0 || stats.focus + focus_per_second < 0):
		return
	stats.focus += spell_focus
	_self_damage(spells.get_pain(spell, "self"))
	var spell_duration = spells.get_duration(spell)
	#todo: animation
	var scene = spells.get_scene(spell)
	if(!scene):
		return
	var spell_scene = scene.instance()
	stats.active_spells.push_back([focus_per_second, spells.get_pain(spell, "self", true), spell_duration, spell_scene])
	add_child(spell_scene)
	#management.call_delayed(spell_scene, "queue_free", null, spell_duration) # done via focus_per_second count

func cancel_spell(active_spell=[]):
	if(active_spell.empty()):
		for x in stats.active_spells:
			if(x.size() > 3):
				x[3].queue_free()
		stats.active_spells = [[]]
	else:
		if(active_spell.size() > 3):
			active_spell[3].queue_free()
		# todo: inefficient array erase
		stats.active_spells.erase(active_spell)

func experience(xp):
	# todo: xp system
	ui.update_xp(xp / 10)

func _act(delta):
	stats.active_spells[0] = [(1 - (stats.pain / stats.max_pain)) * 6, stats.focus / stats.max_focus * -3]
	var canceled_spells = []
	for x in stats.active_spells:
		if(x.size() > 3):
			x[2] -= delta
			if(x[2] <= 0 || stats.focus + x[0] * delta < 0):
				canceled_spells.push_back(x)
				continue
		stats.focus = clamp(stats.focus + x[0] * delta, 0, stats.max_focus)
		_self_damage(x[1] * delta)
	for x in canceled_spells:
		cancel_spell(x)

var last_speed = Vector3.ZERO
func _collide(delta):
	var d_x = abs(last_speed.x - stats.velocity.x) / delta
	var d_y = abs(last_speed.y - stats.velocity.y) / delta
	var d_z = abs(last_speed.z - stats.velocity.z) / delta
	var max_axis = max(d_x, max(d_y, d_z))
	var threshold = 600
	if(max_axis > threshold):
		var dmg = pow((max_axis - threshold*0.8)/100, 2)
		errors.test("impact: " + str(max_axis) + "; dmg: " + str(dmg) + "velo: " + str(stats.velocity) + "; last: " + str(last_speed))
		_self_damage(dmg)
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if(collision.collider.has_method("damage")):
				collision.collider.damage(dmg)
	last_speed = stats.velocity

func _move(delta):
	if(stats.jump_requested):
		stats.velocity.y = stats.JUMP_VELOCITY
		stats.jump_requested = false
	var move_direction = stats.input_direction.rotated(Vector3.UP, rotation.y).normalized()

	var hv = Vector3(stats.velocity.x, 0, stats.velocity.z)

	var max_speed = stats.move_dict[stats.move_state]
	var new_pos = move_direction * max_speed
	var accel = stats.ACCELERATION if(move_direction.dot(hv) > 0) else stats.DE_ACCELERATION

	# todo: check if multiplication with delta is correct
	hv = hv.linear_interpolate(new_pos, accel * delta)

	stats.velocity.y += stats.GRAVITY * delta
	stats.velocity = move_and_slide(Vector3(hv.x, stats.velocity.y, hv.z), Vector3.UP, true, 4, 0.25)

const player_input = preload("res://characters/player/player_input.gd")
func _input(event):
	if(!stats.is_player):
		return
	player_input.move(self, event)
	player_input.camera_move(self, event)
	player_input.action(self, event)

func _update_ui():
	if(ui):
		ui.update_pain(stats.pain / stats.max_pain * 100)
		ui.update_focus(stats.focus / stats.max_focus * 100)
		ui.update_debug(str(stats.velocity))
	health_bar.material = health_bar.material.duplicate()
	health_bar.material.set_shader_param("percentage", 1 - stats.pain / stats.max_pain)
	var dir_to_player = management.player.global_transform.origin.direction_to(global_transform.origin)
	#health_bar.material.set_shader_param("angle", dir_to_player.angle_to(rotation_degrees.y))
	#health_bar.look_at(management.player.transform.origin, Vector3.UP)

func _dialogue(delta):
	for x in stats.is_in_dialog:
		# todo: distance_squared_to
		var dialog_intensity = 1 - clamp((x.translation.distance_to(translation) - 3)/10, 0, 1)
		if(dialog_intensity <= 0):
			end_dialogue()
		ui.update_dialogue(dialog_intensity)

func start_dialogue(actor):
	end_dialogue()
	stats.is_in_dialog.push_back(actor)
	if(ui):
		ui.start_dialogue()

func end_dialogue():
	for x in stats.is_in_dialog:
		# TODO: might cause seg faul because of erase in loop
		stats.is_in_dialog.erase(x)
		x.end_dialogue()
	if(ui):
		ui.end_dialogue()

func interact(actor):
	if(!stats.is_in_dialog.empty()):
		end_dialogue()
	start_dialogue(actor)
	actor.start_dialogue(self)

func _on_interact_area_body_entered(body):
	if(body.has_method("interact")):
		stats.interact_target = body

func _on_interact_area_body_exited(body):
	if(stats.interact_target == body):
		stats.interact_target = null
