extends Control

@onready var buttons: VBoxContainer = $"buttons"
@onready var list: RichTextLabel = $"list"

func _on_inventory_panel_visibility_changed():
	if(is_visible()):
		update_logs()

func update_logs(category=""):
	for x in buttons.get_children():
		buttons.remove_child(x)
	for x in game.mgmt.player_history:
		buttons.add_child(create_name_button(x))
	var history_entry: String = ""
	for x in game.mgmt.player_history:
		if(x == category || category.is_empty()):
			var char_data: Dictionary = game.get_character_data(x)
			var dialogue_data: Dictionary = char_data.get("dialogue", {})
			errors.debug_assert(dialogue_data.has("name") && dialogue_data.has("description") && dialogue_data.has("background"), "character " + x + " has undefined dialogue data")
			history_entry += dialogue_data.get("name", "")
			history_entry += ": "
			history_entry += dialogue_data.get("description", "")
			history_entry += "\n"
			history_entry += dialogue_data.get("background", "")
			history_entry += "\n\n"
			# TODO: implement player_logs
			for a in game.mgmt.player_logs.get(x, []):
				for b in a:
					history_entry += b
		list.set_bbcode(history_entry)

func create_name_button(char_id: String) -> Button:
	var button: Button = Button.new()
	button.set_text(game.get_character_data(char_id).get("dialogue", {}).get("name", "???"))
	errors.error_test(button.connect("pressed", Callable(self, "_on_name_pressed").bind(char_id)))
	return button

func _on_name_pressed(char_id: String):
	update_logs(char_id)
