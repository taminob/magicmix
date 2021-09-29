extends Control

onready var slots = [$"slot0/slot", $"slot1/slot", $"slot2/slot", $"slot3/slot", $"slot4/slot"]

func update_slots():
	for i in range(min(game.mgmt.player.inventory.spell_slots.size(), slots.size())):
		var spell = skill_data.spells[game.mgmt.player.inventory.get_spell_slot(i)]
		slots[i].set_normal_texture(spell.icon())
