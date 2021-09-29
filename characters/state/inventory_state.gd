extends Node

class_name inventory_state

var spell_slots: Array = ["", "", "", "", ""]

var skill_slots: Array = ["", ""]

var things: Array

var spells: Array

var skill_points: int
var skills: Array

func set_spell_slot(num: int, spell: String):
	spell_slots[num] = spell
	game.mgmt.ui.update_slots()

func get_spell_slot(num: int) -> String:
	return spell_slots[num]

func add_spell(spell: String) -> bool:
	if(!spells.has(spell)):
		spells.push_back(spell)
		return true
	return false

func save(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	_inventory_state["spells"] = spells
	_inventory_state["skills"] = skills
	_inventory_state["things"] = things
	_inventory_state["spell_slots"] = spell_slots
	_inventory_state["skill_slots"] = skill_slots
	_inventory_state["skill_points"] = skill_points
	state_dict["inventory"] = _inventory_state

func init(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	spells = _inventory_state.get("spells", [""])
	skills = _inventory_state.get("skills", [""]) # todo? enable do_nothing skill?
	skill_points = _inventory_state.get("skill_points", 5) # TODO? balance start skill points?
	things = _inventory_state.get("things", [])
	spell_slots = _inventory_state.get("spell_slots", ["", "", "", "", ""])
	skill_slots = _inventory_state.get("skill_slots", ["", ""])
