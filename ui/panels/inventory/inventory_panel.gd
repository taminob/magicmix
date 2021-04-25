extends Control

onready var all = $"tabs/All"
onready var weapons = $"tabs/Weapons"
onready var consumables = $"tabs/Consumables"

func update_inventory():
	for x in inventory.items:
		var item = items.items[x]
		all.add_item(item["name"], item["icon"])
		if(items.items[x]["category"] == "weapon"):
			weapons.add_item(item["name"], item["icon"])
		if(items.items[x]["category"] == "consumable"):
			consumables.add_item(item["name"], item["icon"])

func _on_sort_button_pressed():
	inventory.items.sort()
	update_inventory()


func _on_tabs_tab_changed(tab):
	update_inventory()
