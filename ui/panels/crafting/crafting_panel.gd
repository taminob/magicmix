extends Control

onready var target = $"crafting_layout/component_layout/target"
onready var type = $"crafting_layout/component_layout/type"
onready var elements = [$"crafting_layout/component_layout/element_1",
	$"crafting_layout/component_layout/element_2",
	$"crafting_layout/component_layout/element_3"]
onready var result_popup = $"result_popup"
onready var popup_timer = $"result_popup/popup_timer"
onready var result_icon = $"result_popup/popup_layout/result_icon"
onready var result_label = $"result_popup/popup_layout/result_label"

func get_components():
	var spell = {}
	spell["target"] = target.selected
	spell["type"] = type.selected
	spell["elements"] = []
	for element in elements:
		if(!element.selected.empty()):
			spell["elements"].push_back(element.selected)
	return spell

func is_combination(combination, elements):
	if(combination.size() > elements.size()):
		return false
	elements.sort()
	combination.sort()
	for i in range(elements.size()):
		if(elements[i] != combination[clamp(i, 0, combination.size()-1)]):
			return false
	return true

func create_spell():
	var components = get_components()
	for x in spells.spells.keys():
		if(spells.spells[x]["combination"]["target"] == components["target"] &&
			spells.spells[x]["combination"]["type"] == components["type"] &&
			is_combination(spells.spells[x]["combination"]["elements"], components["elements"])):
			return x
	return ""

func _on_cast_button_pressed():
	var new_spell = create_spell()
	if(new_spell != ""):
		if(inventory.add_spell(new_spell)):
			result_label.set_text("New! " + spells.spells[new_spell]["name"])
		else:
			result_label.set_text(spells.spells[new_spell]["name"])
	else:
		result_label.set_text("Invalid Combination!")
	result_icon.set_texture(load(spells.spells[new_spell]["icon"]))
	result_popup.show()
	popup_timer.start()

func _on_popup_timer_timeout():
	result_popup.hide()