extends KinematicBody2D

#warning-ignore-all:unused_class_variable

#onready var collision = $"character_collision"
onready var sprite = $"sprite"
onready var health_bar = $"health_bar"

onready var state = $"state"
onready var move = state.move
onready var experience = state.experience
onready var inventory = state.inventory
onready var stats = state.stats
onready var skills = state.skills
onready var dialogue = state.dialogue
onready var interaction = state.interaction

#onready var camera_pivot = $"camera_pivot"

func _ready():
	VisualServer.canvas_item_set_sort_children_by_y(get_canvas_item(), true)
	init_state()

func save_state():
	state.save()

func init_state():
	state.init()

func set_player(is_player):
	errors.log(name + " is now player-controlled!")
	state.is_player = is_player

func _physics_process(delta):
	if(move.can_move()):
		move.move_process(delta)
		skills.skill_process(delta)
		dialogue.dialogue_process(delta)
	else:
		move.move_dead(delta)
	move.collide(delta)
	_update_ui()

# warning-ignore:unused_class_variable
var interaction_name = "Talk"
func interact(interactor):
	interactor.dialogue.start_dialogue(dialogue)
	dialogue.start_dialogue(interactor.dialogue)

func damage(dmg):
	stats.damage(dmg)

func die():
	errors.log("died: " + name)
	stats.die()

func revive():
	errors.log("revive: " + name)
	stats._self_revive()

func _update_ui():
	if(state.is_player):
		game.mgmt.ui.update_pain(stats.pain / stats.max_pain())
		game.mgmt.ui.update_focus(stats.focus / stats.max_focus())
		game.mgmt.ui.update_stamina(stats.stamina / stats.max_stamina())
		game.mgmt.ui.update_xp(0.4)
		game.mgmt.ui.update_debug(str(move.velocity))
		game.mgmt.ui.update_slots()
	health_bar.set_value((1 - stats.pain / stats.max_pain()) * 100)
	#health_bar.material = health_bar.material.duplicate()
	#health_bar.material.set_shader_param("percentage", 1 - stats.pain / stats.max_pain())
	#var dir_to_player = game.mgmt.player.global_transform.origin.direction_to(global_transform.origin)
	#health_bar.material.set_shader_param("angle", dir_to_player.angle_to(rotation_degrees.y))
	#health_bar.look_at(game.mgmt.player.transform.origin, Vector3.UP)
