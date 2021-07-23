extends Node

class_name skills_state

onready var pawn: KinematicBody = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"
onready var experience: Node = $"../experience"
onready var inventory: Node = $"../inventory"

var active_skills

func cast(spell_id: String):
	if(!inventory.skills.has(spell_id)):
		return
	var spell: abstract_spell = skill_data.spells[spell_id]
	var spell_focus = spell.self_focus()
	var focus_per_second = spell.self_focus_per_second()
	if(stats.focus + spell_focus < 0 || stats.focus + focus_per_second < 0):
		return
	experience.concentration += abs(spell_focus / 1000)
	stats._self_focus_damage(spell_focus)
	stats._self_damage(spell.self_pain())
	var spell_duration = spell.duration()
	# todo: animation
	var spell_scene = spell.scene()
	if(!spell_scene):
		return
	active_skills.push_back([focus_per_second, spell.self_pain_per_second(), spell_duration, spell_scene])
	pawn.add_child(spell_scene)

func cast_slot(slot_id: int):
	cast(inventory.get_skill_slot(slot_id))

func cancel_spell(active_spell=[]):
	if(active_spell.empty()):
		for x in active_skills:
			if(x.size() > 3):
				x[3].queue_free()
		active_skills = [[]]
	else:
		if(active_spell.size() > 3):
			active_spell[3].queue_free()
		# todo? performance: inefficient array erase, optimization prob required
		active_skills.erase(active_spell)

func skill_process(delta: float):
	stats.stamina = clamp(stats.stamina + (stats.stamina_per_second() + move.stamina_cost()) * delta, 0, stats.max_stamina())
	active_skills[0] = [stats.focus_per_second(), stats.pain_per_second()]
	var canceled_spells = []
	for x in active_skills:
		if(x.size() > 3):
			x[2] -= delta
			if(x[2] <= 0 || stats.focus + x[0] * delta < 0):
				canceled_spells.push_back(x)
				continue
		stats._self_focus_damage(x[0] * delta)
		stats._self_damage(x[1] * delta)
	for x in canceled_spells:
		cancel_spell(x)

func save(state_dict: Dictionary):
	# todo: crash when saving with skill scene active
	var _skills_state = state_dict.get("skills", {})
	_skills_state["active_skills"] = [[]]#active_skills
	state_dict["skills"] = _skills_state

func init(state_dict: Dictionary):
	var _skills_state = state_dict.get("skills", {})
	active_skills = _skills_state.get("active_skills", [[]])
