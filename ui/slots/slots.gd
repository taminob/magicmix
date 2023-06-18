extends Control

class_name ui_slots

@onready var slots: Array = [
	$"slot0/slot",
	$"slot1/slot",
	$"slot2/slot",
	$"slot3/slot",
	$"slot4/slot"]
@onready var cooldowns: Array = [
	$"slot0/slot/cooldown",
	$"slot1/slot/cooldown",
	$"slot2/slot/cooldown",
	$"slot3/slot/cooldown",
	$"slot4/slot/cooldown"]

func update_slots():
	for i in range(slots.size()):
		var spell_id: String = game.mgmt.player.inventory.get_spell_slot(game.mgmt.player.skills.current_element, i)
		var spell: abstract_spell = skill_data.spells[spell_id]
		if(spell.cooldown() > 0.0):
			cooldowns[i].set_value(game.mgmt.player.skills.cooldowns.get(spell_id, 0.0) / spell.cooldown())
		else:
			cooldowns[i].set_value(0.0)
		slots[i].set_texture_normal(spell.icon())
