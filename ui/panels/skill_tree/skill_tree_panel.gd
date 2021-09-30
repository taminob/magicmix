extends Control

onready var tree: Panel = $"skill_tree"
onready var details: Panel = $"details"
onready var detail_icon: TextureRect = $"details/icon"
onready var detail_label: Label = $"details/label"
onready var skill_point_display: Label = $"details/skill_point_display"
onready var invest_button: Button = $"details/invest_button"
onready var buttons: Array = [$"buttons/life", $"buttons/darkness", $"buttons/fire", $"buttons/ice", $"buttons/blood"]
var current_category: String = ""

func _on_skill_tree_panel_visibility_changed():
	if(is_visible()):
		update_panel()

func update_panel(reset: bool=true):
	if(reset):
		clear_details()
	tree.update_tree(current_category)
	_highlight_current_button()
	_update_invest_button()
	skill_point_display.set_text("Available Skill Points: " + str(game.mgmt.player.inventory.skill_points))

func _highlight_current_button():
	for x in buttons:
		x.pressed = false
	var button_index: int = ["life", "darkness", "fire", "ice", "blood"].find(current_category)
	if(button_index >= 0):
		buttons[button_index].pressed = true

func _update_invest_button():
	if(!details.has_meta("current") || game.mgmt.player.inventory.skill_points <= 0):
		invest_button.disabled = true
		return
	var skill_id: String = details.get_meta("current")
	var skill: abstract_skill = skill_data.skills[skill_id]
	invest_button.disabled = game.mgmt.player.inventory.skills.has(skill_id)
	for x in skill.requirements():
		if(!game.mgmt.player.inventory.skills.has(x)):
			invest_button.disabled = true

func _on_life_pressed():
	current_category = "life"
	update_panel()

func _on_fire_pressed():
	current_category = "fire"
	update_panel()

func _on_ice_pressed():
	current_category = "ice"
	update_panel()

func _on_darkness_pressed():
	current_category = "darkness"
	update_panel()

func _on_blood_pressed():
	current_category = "blood"
	update_panel()

func clear_details():
	if(details.has_meta("current")):
		details.remove_meta("current")
	detail_icon.set_texture(load(abstract_skill.SKILL_ICONS_PATH + "../empty-512.png"))
	detail_label.set_text("")

func _on_skill_activated(skill_id: String):
	var skill: abstract_skill = skill_data.skills[skill_id]
	details.set_meta("current", skill_id)
	detail_icon.set_texture(skill.icon())
	detail_label.set_text(skill.name() + "\n" + skill.description())
	_update_invest_button()

func _on_skill_point_invested():
	if(details.has_meta("current")):
		var skill_id: String = details.get_meta("current")
		if(game.mgmt.player.inventory.skill_points > 0 &&
			!game.mgmt.player.inventory.skills.has(skill_id)):
			game.mgmt.player.inventory.skill_points -= 1
			game.mgmt.player.inventory.skills.push_back(skill_id)
			update_panel(false)
