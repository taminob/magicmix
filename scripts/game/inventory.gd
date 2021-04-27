extends Node

var slots = ["", "", "", "", ""]

var items = []

var spells = []

var ui_slots = null

func set_action_slot(num, action):
	slots[num] = action
	if(ui_slots):
		ui_slots.update_slots()

func get_action_slot(num):
	return slots[num]

func add_spell(spell):
	if(!spells.has(spell)):
		spells.push_back(spell)
		return true
	return false
