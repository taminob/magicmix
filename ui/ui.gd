extends Control

class_name ui

onready var pain_bar: TextureProgress = $"pain_bar"
onready var shield_bar: TextureProgress = $"shield_bar"
onready var shield_element_icon: TextureRect = $"shield_bar/shield_element_icon"
onready var focus_bar: TextureProgress = $"focus_bar"
onready var stamina_bar: TextureProgress = $"stamina_bar"
onready var xp_bar: ProgressBar = $"xp_bar"
onready var slots: Control = $"slots"
onready var skill_slots: Control = $"skill_slots"
onready var dialogue: ui_dialogue = $"dialogue"
onready var interaction: Control = $"interaction"
onready var debug_label: Label = $"debug_info_label"

func _ready():
	game.mgmt.ui = self

func _process(_delta: float):
	if(settings.get_setting("graphics", "show_fps")):
		$"fps_label".text = str("FPS:",(Engine.get_frames_per_second()))
	else:
		$"fps_label".visible = false

func _on_menu_button_pressed():
	$"../pause_menu".pause()

func reset():
	end_dialogue()
	hide_interaction()

func update_pain(percentage: float):
	pain_bar.set_value(percentage * 100)

func update_shield(percentage: float):
	shield_bar.set_value(percentage * 100)

func update_shield_element(element: int):
	var ICON_PATH: String = "res://ui/icons/"
	match element:
		abstract_spell.element_type.physical:
			shield_element_icon.set_texture(load(ICON_PATH + "skills/defense-512.png"))
		abstract_spell.element_type.life:
			shield_element_icon.set_texture(load(ICON_PATH + "skills/circle-512.png"))
		abstract_spell.element_type.darkness:
			shield_element_icon.set_texture(load(ICON_PATH + "skills/darkness-512.png"))
		abstract_spell.element_type.fire:
			shield_element_icon.set_texture(load(ICON_PATH + "skills/flame-512.png"))
		abstract_spell.element_type.ice:
			shield_element_icon.set_texture(load(ICON_PATH + "skills/blue_star-512.png"))
		_:
			shield_element_icon.set_texture(load(ICON_PATH + "empty-512.png"))

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

func update_skill_slots():
	skill_slots.update_skills()
	skill_slots.update_element()

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

# todo: interaction icon
func show_interaction(text: String, _icon: Texture):
	interaction.get_node("text").set_bbcode("[center]" + text + "[/center]")
	interaction.set_visible(true)

func hide_interaction():
	interaction.set_visible(false)
