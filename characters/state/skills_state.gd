extends Node

class_name skills_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"
onready var experience: Node = $"../experience"
onready var inventory: Node = $"../inventory"

var active_spells: Array
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
	var spell_duration = spell.duration()
	# todo: animation
	var spell_scene = spell.scene()
	if(!spell_scene):
		return
	active_spells.push_back([spell.self_focus_per_second(), spell.self_pain_per_second(), spell_duration, spell_scene])
	pawn.add_child(spell_scene)

func cast_slot(slot_id: int):
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

func activate_skill(skill_id: String):
	if(!inventory.skills.has(skill_id)):
		return
	var skill = skill_data.skills[skill_id] # todo? type abstract_skill
	var skill_focus = skill.self_focus()
	if(stats.focus + skill_focus < 0 || stats.focus + skill.self_focus_per_second() < 0):
		return
	experience.concentration += abs(skill_focus / 1000)
	stats._self_focus_damage(skill_focus)
	stats._self_raw_damage(skill.self_pain()) # todo: elemental damage
	var skill_duration = skill.duration()
	active_skills.push_back([skill.self_focus_per_second(), skill.self_pain_per_second(), skill_duration])
	# todo: animation? scene?

func skill_process(delta: float):
	stats.stamina = min(stats.stamina + (stats.stamina_per_second() + move.stamina_cost()) * delta, stats.max_stamina())
	if(stats.stamina < 0):
		move.current_mode = move_state.move_mode.RUNNING
		stats.stamina = 0
	stats.shield = clamp(stats.shield + stats.shield_per_second(), 0, stats.max_shield())
	active_spells[0] = [stats.focus_per_second(), stats.pain_per_second()]
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
	_skills_state["active_spells"] = [[]]#active_spells
	state_dict["skills"] = _skills_state

func init(state_dict: Dictionary):
	var _skills_state = state_dict.get("skills", {})
	active_spells = _skills_state.get("active_spells", [[]])
