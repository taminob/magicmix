extends Node

class_name stats_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var experience: Node = $"../experience"
onready var skills: Node = $"../skills"
onready var look: Node = $"../look"

var dead: bool
var pain: float
var shield: float
var shield_element: int
var focus: float
var stamina: float
var undead: bool

func pain_percentage() -> float:
	return pain / max_pain()

func shield_percentage() -> float:
	return shield / max_shield()

func focus_percentage() -> float:
	return focus / max_focus()

func stamina_percentage() -> float:
	return stamina / max_stamina()

func max_pain() -> float:
	return experience.sturdiness * 100.0

func max_shield() -> float:
	return min(experience.sturdiness, experience.concentration) * 50.0

func max_focus() -> float:
	return experience.concentration * 100.0

func max_stamina() -> float:
	return experience.endurance * 100.0

func pain_per_second() -> float:
	return experience.sturdiness * focus_percentage() * -3

func shield_per_second() -> float:
	return -0.2 * max_shield() # todo: balance shield gain

func focus_per_second() -> float:
	return experience.concentration * (1 - pain_percentage()) * 6

func stamina_per_second() -> float:
	return experience.endurance * focus_percentage() * 6

func die():
	skills.cancel_spell()
	look.update_look()

	dead = true
	pain = max_pain()
	# todo: animation
	if(state.is_player && !game.levels.current_level_death_realm):
		pawn._update_ui() # todo: refactor? only occurence of pawn
		game.levels.change_level("death_realm")

func damage(dmg: float, element: int):
	match element:
		abstract_spell.element_type.focus:
			_self_focus_damage(dmg)
		abstract_spell.element_type.raw:
			_self_raw_damage(dmg)
		_:
			_self_elemental_damage(dmg, element)

func _self_elemental_damage(dmg: float, element: int):
	if(element == shield_element):
		shield -= dmg
		if(shield < 0):
			_self_raw_damage(-shield)
			shield = 0
	else:
		_self_raw_damage(dmg)

func _self_raw_damage(dmg: float):
	if(settings.get_setting("dev", "god_mode") || dead || game.levels.current_level_death_realm):
		return
	pain = clamp(pain + dmg, 0, max_pain())
	if(pain >= max_pain()):
		die()
	if(dmg >= 1): # todo: adjust value and think about better reconsider system
		state.ai.should_reconsider = true

func _self_focus_damage(dmg: float):
	if(settings.get_setting("dev", "god_mode")):
		return
	focus = clamp(focus + dmg, 0, max_focus())
	if(dmg >= 1): # todo: adjust value and think about better reconsider system
		state.ai.should_reconsider = true

func add_shield(num: float):
	shield = clamp(shield + num, 0, max_shield())

func revive():
	if(undead):
		return
	look.update_look()
	pain = 0.0
	dead = false
	state.ai.should_reconsider = true

func save(state_dict: Dictionary):
	var _stats_state = state_dict.get("stats", {})
	_stats_state["dead"] = dead
	_stats_state["undead"] = undead
	_stats_state["pain"] = pain
	_stats_state["shield"] = shield
	_stats_state["shield_element"] = shield_element
	_stats_state["focus"] = focus
	_stats_state["stamina"] = stamina
	state_dict["stats"] = _stats_state

func init(state_dict: Dictionary):
	var _stats_state = state_dict.get("stats", {})
	undead = _stats_state.get("undead", false)
	if(_stats_state.get("dead", false)):
		die()
	pain = _stats_state.get("pain", 0.0)
	shield = _stats_state.get("shield", 0.0)
	shield_element = _stats_state.get("shield_element", abstract_spell.element_type.raw) # todo: do not allow raw shield
	focus = _stats_state.get("focus", 0.0)
	stamina = _stats_state.get("stamina", 0.0)
