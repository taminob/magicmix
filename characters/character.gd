extends KinematicBody

#onready var collision = $"character_collision"
onready var mesh = $"character_mesh"
onready var health_bar = $"health_bar"

onready var state = $"state"
onready var move = state.move
onready var experience = state.experience
onready var inventory = state.inventory
onready var stats = state.stats
onready var skills = state.skills
onready var dialogue = state.dialogue

#onready var camera_pivot = $"camera_pivot"

func _ready():
	init_state()

func save_state():
	state.save()

func init_state():
	state.init()

func set_player(is_player):
	state.is_player = is_player

func _physics_process(delta):
	if(move.can_move()):
		move.collide(delta)
		move.move(delta)
		skills._act(delta)
		_dialogue(delta)
	else:
		move.move_dead(delta)
	_update_ui()

func damage(dmg):
	stats.damage(dmg)

func revive():
	stats._self_revive()

const player_input = preload("res://characters/player/player_input.gd")
func _input(event):
	if(!state.is_player):
		return
	player_input.move(self, event)
	player_input.camera_move(self, event)
	player_input.action(self, event)

func _update_ui():
	if(state.is_player):
		management.ui.update_pain(stats.pain / stats.max_pain())
		management.ui.update_focus(stats.focus / stats.max_focus())
		management.ui.update_stamina(stats.stamina / stats.max_stamina())
		management.ui.update_xp(0.4)
		management.ui.update_debug(str(move.velocity))
		management.ui.update_slots()
	health_bar.material = health_bar.material.duplicate()
	health_bar.material.set_shader_param("percentage", 1 - stats.pain / stats.max_pain())
	#var dir_to_player = management.player.global_transform.origin.direction_to(global_transform.origin)
	#health_bar.material.set_shader_param("angle", dir_to_player.angle_to(rotation_degrees.y))
	#health_bar.look_at(management.player.transform.origin, Vector3.UP)

func _dialogue(delta):
	for x in dialogue.dialogue_partners:
		# todo: distance_squared_to
		var dialogue_intensity = 1 - clamp((x.translation.distance_to(translation) - 3)/10, 0, 1)
		if(dialogue_intensity <= 0):
			dialogue.end_dialogue()
			if(state.is_player):
				management.ui.start_dialogue()
		if(state.is_player):
			management.ui.update_dialogue(dialogue_intensity)

func interact(actor):
	if(!state.is_in_dialog.empty()):
		dialogue.end_dialogue()
	dialogue.start_dialogue(actor)
	actor.dialogue.start_dialogue(self)
	if(actor.state.is_player || state.is_player):
		management.ui.start_dialogue()

var interact_target = null
func _on_interact_area_body_entered(body):
	if(body.has_method("interact")):
		interact_target = body

func _on_interact_area_body_exited(body):
	if(interact_target == body):
		interact_target = null
