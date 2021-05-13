extends Node


var slots = ["", "", "", "", ""]

var things = []

var skills = []

func set_skill_slot(num, action):
	slots[num] = action
	game.mgmt.ui.update_slots()

func get_skill_slot(num):
	return slots[num]

func add_skill(skill):
	if(!skills.has(skill)):
		skills.push_back(skill)
		return true
	return false

func save(_state):
	var _inventory_state = _state.get("inventory", {})
	_inventory_state["skills"] = skills
	_inventory_state["things"] = things
	_inventory_state["slots"] = slots
	_state["inventory"] = _inventory_state

func init(_state):
	var _inventory_state = _state.get("inventory", {})
	skills = _inventory_state.get("skills", [])
	things = _inventory_state.get("things", [])
	slots = _inventory_state.get("slots", ["", "", "", "", ""])
