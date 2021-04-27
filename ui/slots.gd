extends GridContainer

onready var slots = [$"space3/slot0/slot", $"slot1/slot", $"slot2/slot", $"slot3/slot", $"slot4/slot"]

func _ready():
	update_slots()
	inventory.ui_slots = self

func update_slots():
	for i in range(slots.size()):
		var spell = spells.spells[inventory.slots[i]]
		slots[i].set_normal_texture(spell["icon"])
