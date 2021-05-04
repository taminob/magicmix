extends Control

onready var pain_bar = $"pain_bar"
onready var focus_bar = $"focus_bar"
onready var stamina_bar = $"stamina_bar"
onready var xp_bar = $"xp_bar"
onready var slots = $"slots"
onready var dialogue = $"dialogue"
onready var debug_label = $"debug_info_label"

func _ready():
	management.ui = self

func _process(delta):
	$"fps_label".text = str("FPS:",(Engine.get_frames_per_second()))

func _on_menu_button_pressed():
	$"../pause_menu".pause()

func update_pain(percentage):
	pain_bar.set_value(percentage * 100)

func update_focus(percentage):
	focus_bar.set_value(percentage * 100)

func update_stamina(percentage):
	stamina_bar.set_value(percentage * 100)

func update_debug(text):
	debug_label.set_text(text)

func update_xp(percentage):
	xp_bar.set_value(percentage * 100)

func update_slots():
	slots.update_slots()

func start_dialogue():
	dialogue.popup()

func end_dialogue():
	dialogue.hide()

func update_dialogue(percentage):
	print(percentage)
	dialogue.set_modulate(Color(1, 1, 1, percentage))
