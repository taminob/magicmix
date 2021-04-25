extends VBoxContainer

onready var option_view = $"../../../option_view"

func back_to_menu():
	settings.save_settings()
	scenes.close_scene()

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		back_to_menu()

func _on_game_category_mouse_entered():
	option_view.set_current_tab(0)

func _on_display_category_mouse_entered():
	option_view.set_current_tab(1)

func _on_graphics_category_mouse_entered():
	option_view.set_current_tab(2)

func _on_sound_category_mouse_entered():
	option_view.set_current_tab(3)

func _on_dev_category_mouse_entered():
	option_view.set_current_tab(4)

func _on_back_category_pressed():
	back_to_menu()
