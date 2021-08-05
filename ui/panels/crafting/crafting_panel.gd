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

func get_components() -> Dictionary:
	var spell = {}
	spell["target"] = target.selected
	spell["type"] = type.selected
	spell["elements"] = []
	for element in elements:
		if(!element.selected.empty()):
			spell["elements"].push_back(element.selected)
	return spell

func is_combination(combination, element_combi) -> bool:
	if(combination.size() > element_combi.size()):
		return false
	element_combi.sort()
	combination.sort()
	for i in range(element_combi.size()):
		if(element_combi[i] != combination[clamp(i, 0, combination.size()-1)]):
			return false
	return true

func create_spell() -> String:
	var components = get_components()
	for x in skill_data.spells.keys():
		for combo in skill_data.spells[x].combinations():
			if(combo["target"] == components["target"] &&
				combo["type"] == components["type"] &&
				is_combination(combo["elements"], components["elements"])):
				return x
	return ""

func _on_cast_button_pressed():
	var new_spell = create_spell()
	if(new_spell != ""):
		if(game.mgmt.player.inventory.add_skill(new_spell)):
			result_label.set_text("New! " + skill_data.spells[new_spell].name())
		else:
			result_label.set_text(skill_data.spells[new_spell].name())
	else:
		result_label.set_text("Invalid Combination!")
	result_icon.set_texture(skill_data.spells[new_spell].icon())
	result_popup.show()
	popup_timer.start()

func _on_popup_timer_timeout():
	result_popup.hide()
