extends KinematicBody

class_name character

#warning-ignore-all:unused_class_variable

onready var collision = $"collision"

var spirit: KinematicBody = null

onready var state: Node = $"state"
onready var move: move_state = state.move
onready var experience: experience_state = state.experience
onready var inventory: inventory_state = state.inventory
onready var stats: stats_state = state.stats
onready var skills: skills_state = state.skills
onready var dialogue: dialogue_state = state.dialogue
onready var interaction: interaction_state = state.interaction
onready var look: look_state = state.look
onready var ai: Node = state.ai

func _ready():
	init_state()

func reset():
	dialogue.end_dialogue()

func save_state():
	state.save()

func init_state():
	state.init()

func set_player(is_player: bool):
	errors.log(name + " is now player-controlled!")
	# todo? switch between input/ai state
	state.is_player = is_player

func _physics_process(delta: float):
	if(move.can_move()):
		move.move_process(delta)
		skills.skill_process(delta)
		dialogue.dialogue_process(delta)
	else:
		move.move_process_dead(delta)
	look.animations_process(delta)
	move.collide_process(delta)
	_update_ui()

func get_interaction() -> String:
	return "Talk"

func interact(interactor: Node):
	dialogue.dialogue_interact(interactor)

func damage(dmg: float, is_focus: bool=false):
	stats.damage(dmg)

func die():
	errors.log("died: " + name)
	stats.die()

func revive():
	errors.log("revive: " + name)
	stats.revive()

func global_body_center() -> Vector3:
	return global_transform.origin + global_transform.basis.y * look.body_height / 2

func global_body_head() -> Vector3:
	return global_transform.origin + global_transform.basis.y * look.body_height

func _update_ui():
	if(state.is_player):
		game.mgmt.ui.update_pain(stats.pain / stats.max_pain())
		game.mgmt.ui.update_focus(stats.focus / stats.max_focus())
		game.mgmt.ui.update_stamina(stats.stamina / stats.max_stamina())
		game.mgmt.ui.update_xp(0.4)
		game.mgmt.ui.update_slots()
	if(name == settings.get_setting("dev", "debug_target")):
		if(state.is_player):
			game.mgmt.ui.update_debug(str(move.velocity))
		else:
			var machine = get_node("state/ai").machine
			var debug_output: String = ""
			for x in machine.action_queue:
				debug_output += x.get_script().get_path().get_file() + "; "
			game.mgmt.ui.update_debug(debug_output)
	var health_bar: Spatial = $"health_bar"
	health_bar.material = health_bar.material.duplicate()
	health_bar.material.set_shader_param("percentage", 1 - stats.pain / stats.max_pain())
	health_bar.look_at(game.mgmt.camera.camera.global_transform.origin, Vector3.UP)
	$"health_bar2".region_rect.size.x = 1 - stats.pain / stats.max_pain()
