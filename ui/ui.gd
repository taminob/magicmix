extends Control

onready var pain_bar = $"pain_bar"
onready var focus_bar = $"focus_bar"
onready var stamina_bar = $"stamina_bar"
onready var xp_bar = $"xp_bar"
onready var slots = $"slots"
onready var dialogue = $"dialogue"
onready var interaction = $"interaction"
onready var debug_label = $"debug_info_label"

func _ready():
	game.mgmt.ui = self

func _process(_delta):
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
	interaction.set_anchor(MARGIN_TOP, 0.5)
	interaction.set_anchor(MARGIN_BOTTOM, 0.58)
	dialogue.popup()

func end_dialogue():
	interaction.set_anchor(MARGIN_TOP, 0.8)
	interaction.set_anchor(MARGIN_BOTTOM, 0.88)
	dialogue.hide()

func update_dialogue(visible_chars, transparency):
	dialogue.update_dialogue(visible_chars, transparency)

func set_dialogue_text(string, speaker, answers=[]):
	dialogue.set_dialogue_text(string, speaker, answers)

# todo: interaction icon
func show_interaction(text, _icon):
	interaction.get_node("text").set_bbcode("[center]" + text + "[/center]")
	interaction.popup()

func hide_interaction():
	interaction.hide()
