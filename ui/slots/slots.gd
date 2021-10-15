extends Control

onready var slots = [$"slot0/slot", $"slot1/slot", $"slot2/slot", $"slot3/slot", $"slot4/slot"]

func update_slots():
	for i in range(slots.size()):
		var spell = skill_data.spells[game.mgmt.player.inventory.get_spell_slot(game.mgmt.player.skills.current_element, i)]
		slots[i].set_normal_texture(spell.icon())
