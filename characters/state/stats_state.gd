extends Node

onready var state = get_parent()
onready var character = $"../.."
onready var experience = $"../experience"
onready var skills = $"../skills"

var dead = false
var pain
var focus
var stamina
var undead

func max_pain():
	return experience.sturdiness * 100.0

func max_focus():
	return experience.concentration * 100.0

func max_stamina():
	return experience.endurance * 100.0

func pain_per_second():
	return experience.sturdiness * focus / max_focus() * -3

func focus_per_second():
	return experience.concentration * (1 - (pain / max_pain())) * 6

func stamina_per_second():
	return experience.endurance * focus / max_focus() * 6

func die():
	var material = character.mesh.material.duplicate()
	material.set("albedo_color", Color(0.9, 0.9, 0.2))
	character.mesh.material_override = material
	dead = true
	# todo: animation
	if(state.is_player && !levels.current_level_death_realm):
		character._update_ui()
		levels.change_level("death_realm")

func damage(dmg):
	_self_damage(dmg)

func _self_damage(dmg):
	if(settings.get_setting("dev", "god_mode") || levels.current_level_death_realm):
		return
	pain = clamp(pain + dmg, 0, max_pain())
	if(pain >= max_pain()):
		die()

func _self_revive():
	pain = 0.0
	dead = false

func save(_state):
	var _stats_state = _state.get("stats", {})
	_stats_state["dead"] = dead
	_stats_state["undead"] = undead
	_stats_state["pain"] = pain
	_stats_state["focus"] = focus
	_stats_state["stamina"] = stamina
	_state["stats"] = _stats_state

func init(_state):
	var _stats_state = _state.get("stats", {})
	undead = _stats_state.get("undead", false)
	if(_stats_state.get("dead", false)):
		die()
	pain = _stats_state.get("pain", 0.0)
	focus = _stats_state.get("focus", 0.0)
	stamina = _stats_state.get("stamina", 0.0)
