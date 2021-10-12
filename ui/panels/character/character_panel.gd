extends Control

onready var head_slot = $"head/slot"
onready var body_slot = $"body/slot"
onready var left_shoe_slot = $"left_shoe/slot"
onready var left_glove_slot = $"left_glove/slot"
onready var right_shoe_slot = $"right_shoe/slot"
onready var right_glove_slot = $"right_glove/slot"

func _on_inventory_panel_visibility_changed():
	if(is_visible() && game.mgmt.player && game.mgmt.player.inventory): # todo: better solution than checking for null (required for level switching with open inventory)
		update_character()

func update_character():
	head_slot.set_normal_texture(load("res://ui/icons/items/head-512.png"))
	body_slot.set_normal_texture(load("res://ui/icons/items/body-512.png"))
	left_shoe_slot.set_normal_texture(load("res://ui/icons/items/left_shoe-512.png"))
	left_glove_slot.set_normal_texture(load("res://ui/icons/items/left_hand-512.png"))
	right_shoe_slot.set_normal_texture(load("res://ui/icons/items/right_shoe-512.png"))
	right_glove_slot.set_normal_texture(load("res://ui/icons/items/right_hand-512.png"))
