extends Popup

var hidden = true

func prepare_leave():
	saves.save()
	get_tree().paused = false # todo: test if unpausing here is a good idea

func unpause():
	hidden = true
	get_tree().paused = false
	hide()

func pause():
	hidden = false
	get_tree().paused = true
	popup()

func _enter_tree():
	if(!hidden):
		get_tree().paused = true
		call_deferred("popup")

func _input(event):
	if(event.is_action_pressed("pause")):
		if(hidden):
			pause()
		else:
			unpause()

func _on_resume_button_pressed():
	unpause()

func _on_options_button_pressed():
	scenes.open_scene_from("res://menu/options_menu/options_menu.tscn")

func _on_titlescreen_button_pressed():
	prepare_leave()
	scenes.close_scene()

func _on_quit_button_pressed():
	prepare_leave()
	get_tree().quit()