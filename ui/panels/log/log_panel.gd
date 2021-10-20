extends Control

onready var buttons = $"layout/buttons"
onready var list = $"layout/list"

func _on_inventory_panel_visibility_changed():
	if(is_visible()):
		update_logs()

func update_logs(category=""):
	list.clear()
	for x in buttons.get_children():
		buttons.remove_child(x)
	for x in game.mgmt.player_history:
		buttons.add_child(create_name_button(x))
	for x in game.mgmt.player_logs.keys():
		if(x == category || category.empty()):
			list.add_item(game.mgmt.player_logs[x])

func create_name_button(char_id: String) -> Button:
	var button: Button = Button.new()
	button.set_text(game.get_character_data(char_id).get("dialogue", {}).get("name", "???"))
	errors.error_test(button.connect("pressed", self, "_on_name_pressed", [char_id]))
	return button

func _on_sort_button_pressed():
	# todo: sorting is done twice
	list.sort_items_by_text()
	game.mgmt.player.inventory.things.sort_custom(self, "things_compare")

func _on_name_pressed(char_id: String):
	update_logs(char_id)

func _on_list_item_activated(index: int):
	pass
