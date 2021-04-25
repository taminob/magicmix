extends Control

onready var load_popup = $"load_popup"
onready var save_list = $"load_popup/layout/save_list"

func _on_continue_button_pressed():
	scenes.open_scene(scenes.game_scene)

func _on_new_button_pressed():
	scenes.game_scene = load("res://main.tscn").instance()
	var list = saves.get_save_list()
	if(!list.empty()):
		saves.current_save = str(int(list.back()) + 1)
	else:
		saves.current_save = "0"
	scenes.open_scene(scenes.game_scene)

func _on_load_button_pressed():
	for save in saves.get_save_list():
		save_list.add_item(save)
	load_popup.popup()
#	scenes.open_scene_from("res://menu/pause_menu/pause_menu.tscn")

func _on_options_button_pressed():
	scenes.open_scene_from("res://menu/options_menu/options_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func load_selected():
	saves.load_save(save_list.get_item_text(save_list.get_index()))
	scenes.game_scene = load("res://main.tscn").instance()
	scenes.open_scene(scenes.game_scene)

func _on_save_list_item_activated(_index):
	load_selected()

func _on_load_save_button_pressed():
	load_selected()
