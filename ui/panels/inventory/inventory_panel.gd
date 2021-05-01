extends Control

onready var list = $"layout/list"

func _on_inventory_panel_visibility_changed():
	if(is_visible()):
		update_inventory()

func update_inventory(category=""):
	list.clear()
	for x in management.player.inventory.things:
		var item = items.items[x]
		if(item["category"] == category || category.empty()):
			list.add_item(item["name"], item["icon"])

func _on_sort_button_pressed():
	list.sort_items_by_text()

func _on_all_pressed():
	update_inventory()

func _on_weapons_pressed():
	update_inventory("weapon")

func _on_armor_pressed():
	update_inventory("armor")

func _on_consumables_pressed():
	update_inventory("consumable")
