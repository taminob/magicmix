extends Control

onready var load_popup = $"load_popup"
onready var save_list = $"load_popup/layout/save_list"
var current_load_selection = -1

func _ready():
	$"center_container/v_box_container/continue_button".disabled = saves.get_save_list().empty()

func start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scenes.open_scene(scenes.game_scene)

func _on_continue_button_pressed():
	start_game()
	saves.load_save(saves.get_save_list().back())

func _on_new_button_pressed():
	start_game()
	saves.new_save()

func _on_load_button_pressed():
	current_load_selection = -1
	save_list.clear()
	for save in saves.get_save_list():
		save_list.add_item(save)
	load_popup.popup()

func _on_options_button_pressed():
	scenes.open_scene_from("res://menu/options_menu/options_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func load_selected():
	if(current_load_selection != -1):
		start_game()
		saves.load_save(save_list.get_item_text(current_load_selection))

func _on_save_list_item_activated(index):
	current_load_selection = index
	load_selected()

func _on_load_save_button_pressed():
	load_selected()

func _on_save_list_item_selected(index):
	current_load_selection = index
