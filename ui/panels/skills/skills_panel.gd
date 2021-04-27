extends Control

onready var list = $"layout/list"
onready var detail_popup = $"layout/list/detail_popup"
onready var detail_icon = $"layout/list/detail_popup/icon"
onready var detail_label = $"layout/list/detail_popup/label"

func _on_skills_panel_visibility_changed():
	detail_popup.hide()
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


func _on_list_item_activated(index):
	detail_popup.popup()
	var current = list.get_item_metadata(index)
	detail_popup.set_meta("current", current)
	detail_icon.set_texture(spells.spells[current]["icon"])
	detail_label.set_text(spells.spells[current]["name"] + "\n" + spells.spells[current]["description"])

func _on_slot_pressed(num):
	inventory.set_action_slot(num, detail_popup.get_meta("current"))
