extends Control

func _process(delta):
	$fps_label.text = str("FPS:",(Engine.get_frames_per_second()))

func _on_menu_button_pressed():
	$"../pause_menu".pause()
