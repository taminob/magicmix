extends Node

class_name inventory_state

onready var pawn: KinematicBody = $"../.."

var spell_slots: Dictionary
var skill_slots: Array = ["", ""]

var things: Array
var spells: Array
var skill_points: int
var skills: Array

func set_spell_slot(num: int, spell_id: String):
	spell_slots[skill_data.spells[spell_id].base_element()][num] = spell_id
	game.mgmt.ui.update_slots()

func get_spell_slot(element: int, num: int) -> String:
	return spell_slots.get(element, ["", "", "", "", ""])[num]

func get_skill_slot(num: int) -> String:
	return skill_slots[num]

func add_spell(spell_id: String) -> bool: # todo? return value necessary?
	if(spells.has(spell_id)):
		return false
	spells.push_back(spell_id)
	return true

func remove_spell(spell_id: String):
	spells.erase(spell_id)

func add_skill(skill_id: String) -> bool:
	if(skill_points > 0 && !skills.has(skill_id) && can_learn_skill(skill_id)):
		skill_points -= 1
		skills.push_back(skill_id)
		skill_data.skills[skill_id].on_allocated(pawn)
		return true
	return false

func can_learn_skill(skill_id: String) -> bool:
	var skill: abstract_skill = skill_data.skills[skill_id]
	for x in skill.requirements():
		if(!skills.has(x)):
			return false
	for x in skill.mutually_exclusive():
		if(skills.has(x)):
			return false
	return true

func can_remove_skill(skill_id: String) -> bool:
	if(!skills.has(skill_id)):
		return false
	for x in skills:
		if(skill_data.skills[x].requirements().has(skill_id)):
			return false
	return true

func remove_skill(skill_id: String):
	if(can_remove_skill(skill_id)):
		skill_data.skills[skill_id].on_retracted(pawn)
		skills.erase(skill_id)
		skill_points += 1

func has_base_skill(element: int) -> bool:
	var base_skills = {
		abstract_spell.element_type.life: "base_life",
		abstract_spell.element_type.darkness: "base_darkness",
		abstract_spell.element_type.fire: "base_fire",
		abstract_spell.element_type.ice: "base_ice"
	}
	return skills.has(base_skills[element])

func save(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	_inventory_state["spells"] = spells
	_inventory_state["skills"] = skills
	_inventory_state["things"] = things
	_inventory_state["spell_slots"] = spell_slots
	_inventory_state["skill_slots"] = skill_slots
	_inventory_state["skill_points"] = skill_points
	state_dict["inventory"] = _inventory_state

var DEFAULT_SPELL_SLOTS: Dictionary = {
	abstract_spell.element_type.raw: ["", "", "", "", ""],
	abstract_spell.element_type.life: ["element_shield", "heal", "summon_minion", "", "invert_gravity"],
	abstract_spell.element_type.fire: ["element_shield", "", "fire_ball", "fire_storm", "fire_ring"],
	abstract_spell.element_type.ice: ["element_shield", "ice_ride", "ice_ball", "ice_wave", ""],
	abstract_spell.element_type.darkness: ["element_shield", "", "", "", ""],
}
func init(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	spells = _inventory_state.get("spells", [""])
	skills = _inventory_state.get("skills", [""]) # todo? enable do_nothing skill?
	for x in skills:
		skill_data.skills[x].on_allocated(pawn)
	skill_points = _inventory_state.get("skill_points", 5) # TODO! balance start skill points?
	things = _inventory_state.get("things", [])
	spell_slots = _inventory_state.get("spell_slots", DEFAULT_SPELL_SLOTS)
	errors.debug_assert(spell_slots.size() == 5, "invalid spell_slots size")
	skill_slots = _inventory_state.get("skill_slots", ["", ""])
	errors.debug_assert(skill_slots.size() == 2, "invalid skill_slots size")
