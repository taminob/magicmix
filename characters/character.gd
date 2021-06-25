extends KinematicBody

class_name character

#warning-ignore-all:unused_class_variable

#onready var collision = $"collision"
onready var debug_mesh: CSGMesh = $"mesh" # todo: remove default debug mesh
onready var mesh: Node = load("res://characters/default/default.tscn").instance()
onready var health_bar: Node = $"health_bar"

var spirit: KinematicBody = null

onready var state: Node = $"state"
onready var move: Node = state.move
onready var experience: Node = state.experience
onready var inventory: Node = state.inventory
onready var stats: Node = state.stats
onready var skills: Node = state.skills
onready var dialogue: Node = state.dialogue
onready var interaction: Node = state.interaction

func _ready():
	init_state()
	add_child(mesh)
	get_node("default/animation_player").get_animation("default").loop = true

func reset():
	dialogue.end_dialogue()

func save_state():
	state.save()

func init_state():
	state.init()

func set_player(is_player: bool):
	errors.log(name + " is now player-controlled!")
	state.is_player = is_player

func _physics_process(delta: float):
	if(move.can_move()):
		move.move_process(delta)
		skills.skill_process(delta)
		dialogue.dialogue_process(delta)
	else:
		move.move_process_dead(delta)
	move.collide_process(delta)
	_update_ui()

# warning-ignore:unused_class_variable
var interaction_name: String = "Talk"
func interact(interactor: Node):
	interactor.dialogue.start_dialogue(dialogue)
	dialogue.start_dialogue(interactor.dialogue)

func damage(dmg: float):
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
		game.mgmt.ui.update_debug(str(move.spirit_velocity))
		game.mgmt.ui.update_slots()
	#health_bar.set_value((1 - stats.pain / stats.max_pain()) * 100)
	health_bar.material = health_bar.material.duplicate()
	health_bar.material.set_shader_param("percentage", 1 - stats.pain / stats.max_pain())
	$"health_bar2".region_rect.size.x = 1 - stats.pain / stats.max_pain();
	#var dir_to_player = game.mgmt.player.global_transform.origin.direction_to(global_transform.origin)
	#health_bar.material.set_shader_param("angle", dir_to_player.angle_to(rotation_degrees.y))
	#health_bar.look_at(game.mgmt.player.transform.origin, Vector3.UP)
