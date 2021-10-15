extends Control

onready var list = $"layout/list"
onready var detail_popup = $"layout/list/detail_popup"
onready var detail_icon = $"layout/list/detail_popup/icon"
onready var detail_label = $"layout/list/detail_popup/label"

func _on_spells_panel_visibility_changed():
	detail_popup.hide()
	if(is_visible()):
		update_spells()

func update_spells(category: String=""):
	list.clear()
	for x in game.mgmt.player.inventory.spells:
		var spell = skill_data.spells.get(x)
		if(spell.category() == category || category.empty()):
			list.add_item(spell.name(), spell.icon())
			list.set_item_metadata(list.get_item_count()-1, x)

func _on_all_pressed():
	update_spells()

func _on_life_pressed():
	update_spells("life")

func _on_fire_pressed():
	update_spells("fire")

func _on_blood_pressed():
	update_spells("blood")

func _on_darkness_pressed():
	update_spells("darkness")

func _set_slot(num: int):
	get_node("layout/list/detail_popup/slots/slot" + 
		str(num)).set_normal_texture(skill_data.spells[game.mgmt.player.inventory.get_spell_slot(skill_data.spells[detail_popup.get_meta("current")].base_element(), num)].icon())

func _on_list_item_activated(index: int):
	var current = list.get_item_metadata(index)
	detail_popup.set_meta("current", current)
	var spell = skill_data.spells[current]
	detail_icon.set_texture(spell.icon())
	detail_label.set_text(spell.name() + "\n" + spell.description())
	for i in range(5):
		_set_slot(i)
	detail_popup.popup()

func _on_slot_pressed(num: int):
	game.mgmt.player.inventory.set_spell_slot(num, detail_popup.get_meta("current"))
	_set_slot(num)
