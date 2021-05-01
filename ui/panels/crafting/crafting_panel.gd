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

func is_combination(combination, elements):
	if(combination.size() > elements.size()):
		return false
	elements.sort()
	combination.sort()
	for i in range(elements.size()):
		if(elements[i] != combination[clamp(i, 0, combination.size()-1)]):
			return false
	return true

func create_skill():
	var components = get_components()
	for x in spells.spells.keys():
		for combo in spells.get_combinations(spells.get_spell(x)):
			if(combo["target"] == components["target"] &&
				combo["type"] == components["type"] &&
				is_combination(combo["elements"], components["elements"])):
				return x
	return ""

func _on_cast_button_pressed():
	var new_skill = create_skill()
	if(new_skill != ""):
		if(management.player.inventory.add_skill(new_skill)):
			result_label.set_text("New! " + spells.get_spell_name(spells.get_spell(new_skill)))
		else:
			result_label.set_text(spells.get_spell_name(spells.get_spell(new_skill)))
	else:
		result_label.set_text("Invalid Combination!")
	result_icon.set_texture(spells.get_icon(spells.get_spell(new_skill)))
	result_popup.show()
	popup_timer.start()

func _on_popup_timer_timeout():
	result_popup.hide()
