extends Node

class_name inventory_state

var slots: Array = ["", "", "", "", ""]

var things: Array = []

var spells: Array = []

func set_skill_slot(num: int, action: String):
	slots[num] = action
	game.mgmt.ui.update_slots()

func get_skill_slot(num: int) -> String:
	return slots[num]

func add_spell(spell: String) -> bool:
	if(!spells.has(spell)):
		spells.push_back(spell)
		return true
	return false

func save(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	_inventory_state["spells"] = spells
	_inventory_state["things"] = things
	_inventory_state["slots"] = slots
	state_dict["inventory"] = _inventory_state

func init(state_dict: Dictionary):
	var _inventory_state = state_dict.get("inventory", {})
	spells = _inventory_state.get("spells", [])
	things = _inventory_state.get("things", [])
	slots = _inventory_state.get("slots", ["", "", "", "", ""])
