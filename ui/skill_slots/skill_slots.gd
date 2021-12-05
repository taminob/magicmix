extends Control

#onready var element_slots = [$"slot1/slot", $"slot2/slot", $"slot3/slot", $"slot4/slot"]
onready var element_slot_backgrounds = [$"slot1", $"slot2", $"slot3", $"slot4"]
onready var skill_slots = [$"slot0/slot", $"slot5/slot"]

func update_skills(): # TODO? currently textures are static, remove?
	for i in range(skill_slots.size()):
		var skill = skill_data.skills[game.mgmt.player.inventory.get_skill_slot(i)]
		skill_slots[i].set_normal_texture(skill.icon())

func update_element():
	match game.mgmt.player.skills.current_element:
		abstract_spell.element_type.darkness:
			_highlight_element(1)
		abstract_spell.element_type.life:
			_highlight_element(0)
		abstract_spell.element_type.fire:
			_highlight_element(2)
		abstract_spell.element_type.ice:
			_highlight_element(3)
		_:
			_highlight_element(-1)

func _highlight_element(index: int):
	for x in element_slot_backgrounds:
		x.set_material(CanvasItemMaterial.new())
	if(index >= 0 && index < element_slot_backgrounds.size()):
		element_slot_backgrounds[index].material.set_blend_mode(BLEND_MODE_ADD)
