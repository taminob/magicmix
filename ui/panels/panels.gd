extends Popup

var hidden = true
onready var tabs = $"tabs"

func open(tab):
	hidden = false
	tabs.set_current_tab(tab)
	popup()

func close():
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
	if(event.is_action_pressed("open_inventory")):
		toggle_open(0)
	if(event.is_action_pressed("open_crafting")):
		toggle_open(1)
	if(event.is_action_pressed("open_skills")):
		toggle_open(2)
