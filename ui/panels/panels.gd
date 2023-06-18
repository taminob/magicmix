extends Popup

var hidden = true
@onready var tabs = $"tabs"

enum {
	character_tab = 0,
	inventory_tab,
	log_tab,
	crafting_tab,
	tree_tab,
	spell_tab
}

func open(tab):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hidden = false
	tabs.set_current_tab(tab)
	popup()

func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hidden = true
	hide()

func toggle_open(tab=tabs.current_tab):
	if(hidden || tab != tabs.current_tab):
		open(tab)
	else:
		close()

func _input(event):
	if(event.is_action_pressed("open_panels")):
		toggle_open()
	if(event.is_action_pressed("open_character")):
		toggle_open(character_tab)
	if(event.is_action_pressed("open_log")):
		toggle_open(log_tab)
	if(event.is_action_pressed("open_inventory")):
		toggle_open(inventory_tab)
	if(event.is_action_pressed("open_crafting")):
		toggle_open(crafting_tab)
	if(event.is_action_pressed("open_skill_tree")):
		toggle_open(tree_tab)
	if(event.is_action_pressed("open_spells")):
		toggle_open(spell_tab)
