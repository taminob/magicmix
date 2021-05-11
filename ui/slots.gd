extends GridContainer

onready var slots = [$"space3/slot0/slot", $"slot1/slot", $"slot2/slot", $"slot3/slot", $"slot4/slot"]

func update_slots():
	for i in range(slots.size()):
		var spell = spells.get_spell(game.mgmt.player.inventory.slots[i])
		slots[i].set_normal_texture(spells.get_icon(spell))
