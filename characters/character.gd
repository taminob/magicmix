extends KinematicBody

class_name character

#warning-ignore-all:unused_class_variable

onready var collision: CollisionShape = $"collision"
onready var detect_zone: Area = $"detect_zone"
onready var ray: RayCast = $"ray"

var spirit: KinematicBody = null

onready var state: Node = $"state"
onready var move: move_state = state.move
onready var experience: experience_state = state.experience
onready var inventory: inventory_state = state.inventory
onready var stats: stats_state = state.stats
onready var skills: skills_state = state.skills
onready var dialogue: Node = state.dialogue # todo? change back to actual type dialogue_state
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

	if(!game.mgmt.player_history.has(name)):
		game.mgmt.player_history.push_back(name)

func _physics_process(delta: float):
	if(game.mgmt.time_paused && !state.is_spirit):
		return
	if(move.can_move()):
		move.move_process(delta)
		if(!state.is_spirit):
			stats.stats_process(delta)
			skills.skill_process(delta)
			dialogue.dialogue_process(delta)
	else:
		if(move.frozen):
			stats.stats_process(delta)
		move.move_process_dead(delta)
	look.animations_process(delta)
	move.collide_process(delta)
	_update_ui()

func get_interaction() -> String:
	return "Talk" if dialogue.can_talk() else ""

func interact(interactor: Node):
	dialogue.dialogue_interacted(interactor)

func damage(dmg: float, element: int, caused_by: KinematicBody=null):
	stats.damage(dmg, element, caused_by)

func die():
	errors.log("died: " + name)
	stats.die()

func revive():
	errors.log("revive: " + name)
	stats.revive()

func global_body_center() -> Vector3:
	return global_transform.origin + global_transform.basis.y * look.size().y / 2

func global_body_head() -> Vector3:
	return global_transform.origin + global_transform.basis.y * look.size().y

func looking_direction() -> Vector3:
	return global_transform.basis.z

func distance_squared(target: Spatial) -> float:
	return global_transform.origin.distance_squared_to(target.global_transform.origin)

func distance(target: Spatial) -> float:
	return global_transform.origin.distance_to(target.global_transform.origin)

func face_target(target: Spatial):
	if(target):
		face_location(target.global_transform.origin)

func face_location(global_location: Vector3):
	look_at(Vector3(global_location.x, global_transform.origin.y, global_location.z), Vector3.UP)

func _update_ui():
	if(state.is_player):
		game.mgmt.ui.update_pain(stats.pain / stats.max_pain())
		game.mgmt.ui.update_shield(stats.shield / stats.max_shield())
		game.mgmt.ui.update_shield_element(stats.shield_element)
		game.mgmt.ui.update_focus(stats.focus / stats.max_focus())
		game.mgmt.ui.update_stamina(stats.stamina / stats.max_stamina())
		game.mgmt.ui.udpate_temperature(stats.temperature / stats.MAX_TEMPERATURE)
		game.mgmt.ui.update_xp(experience.experience_progress())
		game.mgmt.ui.update_casttime(skills.current_casttime / skills.current_spell.casttime() if skills.current_spell && skills.current_spell.casttime() > 0.0 else 0.0)
		game.mgmt.ui.update_slots()
		game.mgmt.ui.update_skill_slots()
	if(name == settings.get_setting("dev", "debug_target")):
		if(state.is_player):
			game.mgmt.ui.update_debug(str(move.velocity))
		else:
			var machine = get_node("state/ai").machine
			var debug_output: String = ""
			for x in machine.action_queue:
				debug_output += x.get_script().get_path().get_file() + "; "

			game.mgmt.ui.update_debug(debug_output)
	var health_bar: MeshInstance = $"health_bar"
	if(!health_bar.material_override):
		health_bar.material_override = health_bar.get_active_material(0).duplicate()
	health_bar.material_override.set_shader_param("percentage", 1 - stats.pain / stats.max_pain())
	health_bar.look_at(game.mgmt.camera.camera.global_transform.origin, Vector3.UP)
	var shield_bar: MeshInstance = $"shield_bar"
	if(!shield_bar.material_override):
		shield_bar.material_override = shield_bar.get_active_material(0).duplicate()
	shield_bar.get_active_material(0).set_shader_param("percentage", stats.shield / stats.max_shield())
	shield_bar.look_at(game.mgmt.camera.camera.global_transform.origin, Vector3.UP)
	var focus_bar: MeshInstance = $"focus_bar"
	if(!focus_bar.material_override):
		focus_bar.material_override = focus_bar.get_active_material(0).duplicate()
	focus_bar.get_active_material(0).set_shader_param("percentage", stats.focus / stats.max_focus())
	focus_bar.look_at(game.mgmt.camera.camera.global_transform.origin, Vector3.UP)
	var quest_symbol: MeshInstance = $"quest_symbol"
	quest_symbol.visible = dialogue.data.wants_to_talk_to.has(game.mgmt.player_id) && !state.is_player
