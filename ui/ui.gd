extends Control

class_name ui

onready var pain_bar: TextureProgress = $"pain_bar"
onready var focus_bar: TextureProgress = $"focus_bar"
onready var stamina_bar: TextureProgress = $"stamina_bar"
onready var xp_bar: ProgressBar = $"xp_bar"
onready var slots: Control = $"slots"
onready var dialogue: Popup = $"dialogue"
onready var interaction: Control = $"interaction"
onready var debug_label: Label = $"debug_info_label"

func _ready():
	game.mgmt.ui = self

func _process(_delta: float):
	$"fps_label".text = str("FPS:",(Engine.get_frames_per_second()))

func _on_menu_button_pressed():
	$"../pause_menu".pause()

func reset():
	end_dialogue()
	hide_interaction()

func update_pain(percentage: float):
	pain_bar.set_value(percentage * 100)

func update_focus(percentage: float):
	focus_bar.set_value(percentage * 100)

func update_stamina(percentage: float):
	stamina_bar.set_value(percentage * 100)

func update_debug(text: String):
	debug_label.set_text(text)

func update_xp(percentage: float):
	xp_bar.set_value(percentage * 100)

func update_slots():
	slots.update_slots()

func start_dialogue():
	interaction.anchor_top = 0.53
	interaction.anchor_bottom = 0.61
	interaction.anchor_left = 0.55
	interaction.anchor_right = 0.85
	dialogue.popup()

func end_dialogue():
	interaction.anchor_top = 0.8
	interaction.anchor_bottom = 0.88
	interaction.anchor_left = 0.35
	interaction.anchor_right = 0.65
	dialogue.hide()

func update_dialogue(delta: float, transparency: float):
	dialogue.update_dialogue(delta, transparency)

func set_dialogue_text(text: String, speaker: String, answers:Array=[], answer_callback:FuncRef=null):
	dialogue.set_dialogue_text(text, speaker, answers, answer_callback)

# todo: interaction icon
func show_interaction(text: String, _icon: Texture):
	interaction.get_node("text").set_bbcode("[center]" + text + "[/center]")
	interaction.set_visible(true)

func hide_interaction():
	interaction.set_visible(false)
