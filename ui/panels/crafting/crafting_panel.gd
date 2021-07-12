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
	var skill = {}
	skill["target"] = target.selected
	skill["type"] = type.selected
	skill["elements"] = []
	for element in elements:
		if(!element.selected.empty()):
			skill["elements"].push_back(element.selected)
	return skill

func is_combination(combination, element_combi):
	if(combination.size() > element_combi.size()):
		return false
	element_combi.sort()
	combination.sort()
	for i in range(element_combi.size()):
		if(element_combi[i] != combination[clamp(i, 0, combination.size()-1)]):
			return false
	return true

func create_skill():
	var components = get_components()
	for x in skill_data.spells.keys():
		for combo in skill_data.spells[x].combinations():
			if(combo["target"] == components["target"] &&
				combo["type"] == components["type"] &&
				is_combination(combo["elements"], components["elements"])):
				return x
	return ""

func _on_cast_button_pressed():
	var new_skill = create_skill()
	if(new_skill != ""):
		if(game.mgmt.player.inventory.add_skill(new_skill)):
			result_label.set_text("New! " + skill_data.spells[new_skill].name())
		else:
			result_label.set_text(skill_data.spells[new_skill].name())
	else:
		result_label.set_text("Invalid Combination!")
	result_icon.set_texture(skill_data.spells[new_skill].icon())
	result_popup.show()
	popup_timer.start()

func _on_popup_timer_timeout():
	result_popup.hide()
