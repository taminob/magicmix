extends Control

onready var details = $"layout/split/details"
onready var detail_icon = $"layout/split/details/icon"
onready var detail_label = $"layout/split/details/label"

func _on_skill_tree_panel_visibility_changed():
	if(is_visible()):
		update_tree()

func update_tree(_category: String=""):
	pass

func _on_life_pressed():
	update_tree("life")

func _on_fire_pressed():
	update_tree("fire")

func _on_darkness_pressed():
	update_tree("darkness")

func _on_blood_pressed():
	update_tree("blood")

func _set_slot(num: int):
	get_node("layout/list/detail_popup/slots/slot" + 
	str(num)).set_normal_texture(skill_data.spells[game.mgmt.player.inventory.get_skill_slot(num)].icon())

func _on_skill_activated(index: int):
	var current = index#list.get_item_metadata(index)
	details.set_meta("current", current)
	var spell: abstract_spell = skill_data.spells[current]
	detail_icon.set_texture(spell.icon())
	detail_label.set_text(spell.name() + "\n" + spell.description())
	for i in range(5):
		_set_slot(i)

func _on_slot_pressed(num: int):
	game.mgmt.player.inventory.set_skill_slot(num, details.get_meta("current"))
	_set_slot(num)
