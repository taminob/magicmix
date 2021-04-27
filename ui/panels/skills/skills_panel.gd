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
	for x in inventory.spells:
		var spell = spells.spells[x]
		if(spell["category"] == category || category.empty()):
			list.add_item(spell["name"], spell["icon"])
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
	get_node("layout/list/detail_popup/slots/slot" + str(num)).set_normal_texture(spells.spells[inventory.get_action_slot(num)]["icon"])

func _on_list_item_activated(index):
	var current = list.get_item_metadata(index)
	detail_popup.set_meta("current", current)
	var spell = spells.spells[current]
	detail_icon.set_texture(spell["icon"])
	detail_label.set_text(spell["name"] + "\n" + spell["description"])
	for i in range(5):
		_set_slot(i)
	detail_popup.popup()

func _on_slot_pressed(num):
	inventory.set_action_slot(num, detail_popup.get_meta("current"))
	_set_slot(num)
