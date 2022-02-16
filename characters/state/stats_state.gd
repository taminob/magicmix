extends Node

class_name stats_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var experience: Node = $"../experience"
onready var skills: Node = $"../skills"
onready var dialogue: Node = $"../dialogue"
onready var look: Node = $"../look"

const MAX_TEMPERATURE: float = 100.0

var dead: bool
var pain: float
var shield: float
var shield_element: int
var focus: float
var stamina: float
var undead: bool
var temperature: float

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

func die(save_state: bool=true):
	pain = max_pain()
	dead = true
	if(undead):
		return
	skills.cancel_spells()
	dialogue.interrupt_dialogue()

	# todo: animation
	if(!game.levels.current_level_data.is_in_death_realm()):
		if(state.is_player): # todo: better undead concept
			pawn._update_ui() # todo: refactor? only occurence of pawn
			game.levels.change_level("death_realm")
		else:
			if(save_state && !state.is_minion):
				pawn.save_state()
			var death_shard: Spatial = preload("res://world/objects/death_shard/death_shard.tscn").instance()
			death_shard.name = "death_shard_" + pawn.name
			game.levels.current_level.call_deferred("add_child", death_shard)
			death_shard.global_transform = pawn.global_transform
			pawn.queue_free()

func damage(dmg: float, element: int, caused_by: KinematicBody):
	if(caused_by):
		# todo: move to dialogue_state
		var new_relation: int = int(clamp(dialogue.get_relation(caused_by.name) - (1 * sign(dmg)), -2, 2)) # TODO? replace constant by enum
		dialogue.set_relation(caused_by.name, new_relation)
		if(dmg > 0.0 && new_relation != -2 && !state.is_minion):#dialogue_state.relation.enemy): # TODO? replace constant by enum
			if(!dialogue.data.wants_to_talk_to.has(caused_by.name)):
				dialogue.data.wants_to_talk_to.push_back(caused_by.name)
			dialogue.data.partners[caused_by.name] = dialogue.data.hurt_warning_conversation() # TODO: save previous value
	match element:
		abstract_spell.element_type.focus:
			_self_focus_damage(dmg)
		abstract_spell.element_type.raw:
			_self_raw_damage(dmg)
		_:
			_self_elemental_damage(dmg, element)

func _self_elemental_damage(dmg: float, element: int):
	if(element == abstract_spell.element_type.raw || element != shield_element):
		_self_raw_damage(dmg)
	else:
		shield = min(shield - dmg, max_shield())
		if(shield < 0):
			_self_raw_damage(-shield)
			shield = 0

var dmg_change_since_reconsider: Dictionary = {"pain": 0, "focus": 0, "shield": 0}
func _self_raw_damage(dmg: float):
	if(settings.get_setting("dev", "god_mode") || dead || game.levels.current_level_data.is_in_death_realm()):
		return
	pain = clamp(pain + dmg, 0, max_pain())
	if(pain >= max_pain()):
		die()
	dmg_change_since_reconsider["pain"] += abs(dmg)
	if(dmg_change_since_reconsider["pain"] > 0.1 * max_pain()): # todo: adjust value and think about better reconsider system
		state.ai.should_reconsider = true
		dmg_change_since_reconsider["pain"] = 0

func _self_focus_damage(dmg: float):
	if(settings.get_setting("dev", "god_mode")):
		return
	focus = clamp(focus + dmg, 0, max_focus())
	dmg_change_since_reconsider["focus"] += abs(dmg)
	if(dmg_change_since_reconsider["focus"] > 0.1 * max_focus()): # todo: adjust value and think about better reconsider system
		state.ai.should_reconsider = true
		dmg_change_since_reconsider["focus"] = 0

func set_shield_element(element: int):
	if(shield_element != element):
		shield = 0.0
		shield_element = element

func add_shield(num: float):
	if(shield_element != abstract_spell.element_type.raw):
		shield = clamp(shield + num, 0, max_shield())
		dmg_change_since_reconsider["shield"] += abs(num)
		if(dmg_change_since_reconsider["shield"] > 0.1 * max_shield()): # todo: adjust value and think about better reconsider system
			state.ai.should_reconsider = true
			dmg_change_since_reconsider["shield"] = 0

func revive():
	if(undead):
		return
	pain = 0.0
	dead = false
	state.ai.should_reconsider = true

func _temperature_process(delta: float):
	if(temperature < -50):
		move.set_frozen(true)
		look.update_look()
		_self_elemental_damage(temperature * 0.1 * delta, abstract_spell.element_type.ice)
	elif(move.frozen):
		move.set_frozen(false)
		look.update_look()
	if(temperature > 50):
		_self_elemental_damage(temperature * delta, abstract_spell.element_type.fire)
	temperature -= sign(temperature) * 10 * delta # todo: tweak temperature normalization value

func stats_process(delta: float):
	stamina = min(stamina + (stamina_per_second() + move.stamina_cost()) * delta, max_stamina())
	if(stamina < 0):
		move.current_mode = move_state.move_mode.RUNNING
		stamina = 0
	shield = clamp(shield + shield_per_second() * delta, 0, max_shield())
	_self_focus_damage(focus_per_second() * delta)
	_self_raw_damage(pain_per_second() * delta)
	_temperature_process(delta)

func save(state_dict: Dictionary):
	var _stats_state = state_dict.get("stats", {})
	_stats_state["dead"] = dead
	_stats_state["undead"] = undead
	_stats_state["pain"] = pain
	_stats_state["shield"] = shield
	_stats_state["shield_element"] = shield_element
	_stats_state["focus"] = focus
	_stats_state["stamina"] = stamina
	_stats_state["temperature"] = temperature
	state_dict["stats"] = _stats_state

func init(state_dict: Dictionary):
	var _stats_state = state_dict.get("stats", {})
	undead = _stats_state.get("undead", false)
	if(_stats_state.get("dead", false) || (state.is_minion && game.levels.current_level_data.is_in_death_realm())):
		die(false)
	else:
		pain = _stats_state.get("pain", 0.0)
	shield = _stats_state.get("shield", 0.0)
	shield_element = _stats_state.get("shield_element", abstract_spell.element_type.raw) # todo: do not allow raw shield
	focus = _stats_state.get("focus", 0.0)
	stamina = _stats_state.get("stamina", 0.0)
	temperature = _stats_state.get("temperature", 0.0)
