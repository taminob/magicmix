extends Node

class_name skills_state

onready var character: character = $"../.."
onready var move: Node = $"../move"
onready var stats: Node = $"../stats"
onready var inventory: Node = $"../inventory"

var active_skills

func cast(spell_id: String):
	var spell = spells.get_spell(spell_id)
	var spell_focus = spells.get_focus(spell, "self")
	var focus_per_second = spells.get_focus(spell, "self", true)
	if(stats.focus + spell_focus < 0 || stats.focus + focus_per_second < 0):
		return
	stats.focus = clamp(stats.focus + spell_focus, 0, stats.max_focus())
	stats._self_damage(spells.get_pain(spell, "self"))
	var spell_duration = spells.get_duration(spell)
	# todo: animation
	var scene = spells.get_scene(spell)
	if(!scene):
		return
	var spell_scene = scene.instance()
	active_skills.push_back([focus_per_second, spells.get_pain(spell, "self", true), spell_duration, spell_scene])
	character.add_child(spell_scene)
	#game.mgmt.call_delayed(spell_scene, "queue_free", spell_duration) # done via focus_per_second count

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
		# todo: inefficient array erase, optimization prob required
		active_skills.erase(active_spell)

func skill_process(delta: float):
	stats.stamina = clamp(stats.stamina + (stats.stamina_per_second() - move.stamina_cost()) * delta, 0, stats.max_stamina())
	active_skills[0] = [stats.focus_per_second(), stats.pain_per_second()]
	var canceled_spells = []
	for x in active_skills:
		if(x.size() > 3):
			x[2] -= delta
			if(x[2] <= 0 || stats.focus + x[0] * delta < 0):
				canceled_spells.push_back(x)
				continue
		stats.focus = clamp(stats.focus + x[0] * delta, 0, stats.max_focus())
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
