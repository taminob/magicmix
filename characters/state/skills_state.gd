extends Node

class_name skills_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"
onready var inventory: Node = $"../inventory"

class active_spell:
	var spell_id: String
	var spell: abstract_spell
	var duration: float
	var scene: Node

	func _init(new_spell_id: String, new_duration: float, pawn: KinematicBody):
		spell_id = new_spell_id
		duration = new_duration
		spell = skill_data.spells[spell_id]
		scene = spell.scene()
		if(scene):
			if("caster" in scene):
				scene.caster = pawn
			game.levels.current_level.add_child(scene)
		spell.start_effect(pawn)

	func can_tick(pawn: KinematicBody, delta: float) -> bool:
		return duration > 0 && (pawn.stats.focus + spell.self_focus_per_second() * delta >= 0 || game.levels.current_level_death_realm)

	func tick(pawn: KinematicBody, delta: float) -> bool:
		duration -= delta
		if(can_tick(pawn, delta)):
			pawn.stats._self_focus_damage(spell.self_focus_per_second() * delta)
			pawn.stats._self_elemental_damage(spell.self_pain_per_second() * delta, spell.self_element()) # todo: elemental self damage from skills?
			spell.effect(pawn, delta)
			return true
		cancel(pawn)
		return false

	func cancel(pawn: KinematicBody):
		spell.end_effect(pawn)
		if(scene):
			scene.queue_free()

	func to_dict() -> Dictionary:
		return {
			"spell_id": spell_id,
			"remaining": duration
		}

	static func from_dict(dict: Dictionary, pawn: KinematicBody) -> active_spell:
		# todo? smart to repeat start_effect when restoring?
		var new_spell: active_spell = active_spell.new(dict["spell_id"], dict["remaining"], pawn)
		return new_spell

var active_spells: Array
var current_element: int

func cast_spell(spell_id: String):
	if(!inventory.spells.has(spell_id)):
		return
	var spell: abstract_spell = skill_data.spells[spell_id]
	if(!can_cast(spell_id)):
		return
	stats._self_focus_damage(spell.self_focus())
	stats._self_elemental_damage(spell.self_pain(), spell.self_element()) # todo: elemental damage
	active_spells.push_back(active_spell.new(spell_id, spell.duration(), pawn))
	# todo: animation

func can_cast(spell_id: String) -> bool:
	if(game.levels.current_level_death_realm):
		return true # todo? remove?
	var spell: abstract_spell = skill_data.spells[spell_id]
	return stats.focus + spell.self_focus() >= 0 && stats.focus + spell.self_focus_per_second() >= 0

func cast_spell_slot(slot_id: int):
	cast_spell(inventory.get_spell_slot(current_element, slot_id))

func cancel_spells():
	for x in active_spells:
		x.cancel(pawn)
	active_spells.clear()

func set_element(new_element: int) -> bool:
	if(inventory.has_base_skill(new_element)):
		current_element = new_element
		game.mgmt.ui.update_skill_slots()
		return true
	return false

func _try_set_element(new_element: int):
	var start_index: int = element_order.find(new_element)
	if(start_index < 0):
		start_index = 0
	if(!set_element(element_order[start_index])):
		var run_index: int = (start_index + 1) % element_order.size()
		while !set_element(element_order[run_index]):
			run_index = (run_index + 1) % element_order.size()
			if(run_index == start_index):
				break

var element_order: Array = [abstract_spell.element_type.life, abstract_spell.element_type.fire, abstract_spell.element_type.ice, abstract_spell.element_type.darkness]
func rotate_element():
	match current_element:
		abstract_spell.element_type.raw:
			_try_set_element(abstract_spell.element_type.life)
		abstract_spell.element_type.darkness:
			_try_set_element(abstract_spell.element_type.life)
		abstract_spell.element_type.life:
			_try_set_element(abstract_spell.element_type.fire)
		abstract_spell.element_type.fire:
			_try_set_element(abstract_spell.element_type.ice)
		abstract_spell.element_type.ice:
			_try_set_element(abstract_spell.element_type.darkness)
		_:
			pass

func invert_element(): # todo? remove unused function
	match current_element:
		abstract_spell.element_type.raw:
# warning-ignore:return_value_discarded
			set_element(abstract_spell.element_type.life)
		abstract_spell.element_type.darkness:
# warning-ignore:return_value_discarded
			set_element(abstract_spell.element_type.life)
		abstract_spell.element_type.life:
# warning-ignore:return_value_discarded
			set_element(abstract_spell.element_type.darkness)
		abstract_spell.element_type.fire:
# warning-ignore:return_value_discarded
			set_element(abstract_spell.element_type.ice)
		abstract_spell.element_type.ice:
# warning-ignore:return_value_discarded
			set_element(abstract_spell.element_type.fire)
		_:
			pass

func skill_process(delta: float):
	stats.stamina = min(stats.stamina + (stats.stamina_per_second() + move.stamina_cost()) * delta, stats.max_stamina())
	if(stats.stamina < 0):
		move.current_mode = move_state.move_mode.RUNNING
		stats.stamina = 0
	stats.shield = clamp(stats.shield + stats.shield_per_second() * delta, 0, stats.max_shield())
	stats._self_focus_damage(stats.focus_per_second() * delta)
	stats._self_raw_damage(stats.pain_per_second() * delta)
	_active_spells_process(delta)
	_active_skills_process(delta)
	# todo: passive skills process?

func _active_spells_process(delta: float):
	var i: int = 0
	while i < active_spells.size():
		if(!active_spells[i].tick(pawn, delta)):
			active_spells.remove(i)
		else:
			i += 1

func _active_skills_process(delta: float):
	for x in inventory.skills:
		skill_data.skills[x].effect(pawn, delta)

func save(state_dict: Dictionary):
	var _skills_state = state_dict.get("skills", {})
	_skills_state["current_element"] = current_element
	var to_store_active_spells: Array = []
	for x in active_spells:
		to_store_active_spells.push_back(x.to_dict())
	_skills_state["active_spells"] = to_store_active_spells
	state_dict["skills"] = _skills_state

func init(state_dict: Dictionary):
	var _skills_state = state_dict.get("skills", {})
	current_element = _skills_state.get("current_element", abstract_spell.element_type.raw) # todo? set element (update ui)
	var stored_active_spells = _skills_state.get("active_spells", [])
	for x in stored_active_spells:
		active_spells.push_back(active_spell.from_dict(x, pawn))
