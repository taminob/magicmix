extends Node

var slots = ["", "", "", ""]

var items = []

var spells = []

var player_character = "mary"

func get_action_slot(num):
	return slots[num]

func add_spell(spell):
	if(!spells.has(spell)):
		spells.push_back(spell)
		return true
	return false
