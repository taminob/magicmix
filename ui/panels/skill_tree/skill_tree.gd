extends Control

onready var details = $"layout/split/details"
onready var detail_icon = $"layout/split/details/icon"
onready var detail_label = $"layout/split/details/label"

func _on_skills_tree_visibility_changed():
	if(is_visible()):
		update_tree()

func update_tree(category=""):
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
	str(num)).set_normal_texture(spells.get_icon(spells.get_spell(
		game.mgmt.player.inventory.get_skill_slot(num))))

func _on_list_item_activated(index: int):
	var current = index#list.get_item_metadata(index)
	details.set_meta("current", current)
	var spell = spells.get_spell(current)
	detail_icon.set_texture(spells.get_icon(spell))
	detail_label.set_text(spells.get_spell_name(spell) + "\n" + spells.get_description(spell))
	for i in range(5):
		_set_slot(i)

func _on_slot_pressed(num: int):
	game.mgmt.player.inventory.set_skill_slot(num, details.get_meta("current"))
	_set_slot(num)
