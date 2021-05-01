extends Control

onready var list = $"layout/list"
onready var detail_popup = $"layout/list/detail_popup"
onready var detail_icon = $"layout/list/detail_popup/icon"
onready var detail_label = $"layout/list/detail_popup/label"

func _on_skills_panel_visibility_changed():
	detail_popup.hide()
	if(is_visible()):
		update_skills()

func update_skills(category=""):
	list.clear()
	for x in management.player.inventory.skills:
		var spell = spells.get_spell(x)
		if(spells.get_category(spell) == category || category.empty()):
			list.add_item(spells.get_spell_name(spell), spells.get_icon(spell))
			list.set_item_metadata(list.get_item_count()-1, x)

func _on_all_pressed():
	update_skills()

func _on_heal_pressed():
	update_skills("heal")

func _on_fire_pressed():
	update_skills("fire")

func _on_blood_pressed():
	update_skills("blood")

func _set_slot(num):
	get_node("layout/list/detail_popup/slots/slot" + 
	str(num)).set_normal_texture(spells.get_icon(spells.get_spell(
		management.player.inventory.get_skill_slot(num))))

func _on_list_item_activated(index):
	var current = list.get_item_metadata(index)
	detail_popup.set_meta("current", current)
	var spell = spells.get_spell(current)
	detail_icon.set_texture(spells.get_icon(spell))
	detail_label.set_text(spells.get_spell_name(spell) + "\n" + spells.get_description(spell))
	for i in range(5):
		_set_slot(i)
	detail_popup.popup()

func _on_slot_pressed(num):
	management.player.inventory.set_skill_slot(num, detail_popup.get_meta("current"))
	_set_slot(num)
