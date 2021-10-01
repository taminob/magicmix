extends Node

class_name skills_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"
onready var experience: Node = $"../experience"
onready var inventory: Node = $"../inventory"

var active_spells: Array
var current_element: int
var active_skills: Array

func cast_spell(spell_id: String):
	if(!inventory.spells.has(spell_id)):
		return
	var spell: abstract_spell = skill_data.spells[spell_id]
	var spell_focus = spell.self_focus()
	if(stats.focus + spell_focus < 0 || stats.focus + spell.self_focus_per_second() < 0):
		return
	experience.concentration += abs(spell_focus / 1000)
	stats._self_focus_damage(spell_focus)
	stats._self_raw_damage(spell.self_pain()) # todo: elemental damage
	var active_spell = [spell.self_focus_per_second(), spell.self_pain_per_second()]
	var spell_duration = spell.duration()
	if(spell_duration > 0):
		active_spell.push_back(spell_duration)
	# todo: animation
	var spell_scene = spell.scene()
	if(spell_scene):
		active_spell.push_back(spell_scene)
	active_spells.push_back(active_spell)
	pawn.add_child(spell_scene)

func cast_spell_slot(slot_id: int):
	cast_spell(inventory.get_spell_slot(slot_id))

func cancel_spell(active_spell=[]):
	if(active_spell.empty()):
		for x in active_spells:
			if(x.size() > 3):
				x[3].queue_free()
		active_spells = [[]]
	else:
		if(active_spell.size() > 3):
			active_spell[3].queue_free()
		# todo? performance: inefficient array erase, optimization prob required
		active_spells.erase(active_spell)

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

func activate_skill(skill_id: String):
	if(!inventory.skills.has(skill_id) || current_element == abstract_spell.element_type.raw):
		return
	var skill = skill_data.skills[skill_id] # todo? type abstract_skill
	var skill_duration = skill.duration()
	if(skill_duration < 0):
		active_skills.push_back([skill])
	else:
		active_skills.push_back([skill, skill_duration])
	skill.start_effect(pawn)
	# todo: animation? scene?

func activate_skill_slot(slot_id: int):
	activate_skill(inventory.get_skill_slot(slot_id))

func deactivate_skill(active_skill: Array = []):
	if(active_skill.empty()):
		for x in active_skills:
			x.end_effect(pawn)
		active_skills = [[]]
	else:
		active_skill[0].end_effect(pawn)
		# todo? performance: inefficient array erase, optimization prob required
		active_skills.erase(active_skill)

func skill_process(delta: float):
	stats.stamina = min(stats.stamina + (stats.stamina_per_second() + move.stamina_cost()) * delta, stats.max_stamina())
	if(stats.stamina < 0):
		move.current_mode = move_state.move_mode.RUNNING
		stats.stamina = 0
	stats.shield = clamp(stats.shield + stats.shield_per_second() * delta, 0, stats.max_shield())
	active_spells[0] = [stats.focus_per_second(), stats.pain_per_second()]
	_active_spells_process(delta)
	_active_skills_process(delta)
	# todo: passive skills process?

func _active_skills_process(delta: float):
	var canceled_skills = []
	for x in active_skills:
		if(x.size() > 1):
			x[1] -= delta
			if(x[1] <= 0):
				canceled_skills.push_back(x)
				continue
		x[0].effect(pawn, delta)
	for x in canceled_skills:
		deactivate_skill(x)

func _active_spells_process(delta: float):
	var canceled_spells = []
	for x in active_spells:
		if(x.size() > 3):
			x[2] -= delta
			if(x[2] <= 0 || stats.focus + x[0] * delta < 0):
				canceled_spells.push_back(x)
				continue
		stats._self_focus_damage(x[0] * delta)
		stats._self_raw_damage(x[1] * delta) # todo: elemental self damage from skills?
	for x in canceled_spells:
		cancel_spell(x)

func save(state_dict: Dictionary):
	# todo? save active_spells (crash when saving with skill scene active)
	var _skills_state = state_dict.get("skills", {})
	_skills_state["current_element"] = current_element
	_skills_state["active_spells"] = [[]]#active_spells
	state_dict["skills"] = _skills_state

func init(state_dict: Dictionary):
	var _skills_state = state_dict.get("skills", {})
	current_element = _skills_state.get("current_element", abstract_spell.element_type.raw) # todo? set element (update ui)
	active_spells = _skills_state.get("active_spells", [[]])
