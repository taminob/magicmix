extends Control

onready var list = $"layout/list"

func _on_inventory_panel_visibility_changed():
	if(is_visible()):
		update_inventory()

func update_inventory(category=""):
	list.clear()
	for x in game.mgmt.player.inventory.things:
		var item = items.items[x]
		if(item["category"] == category || category.empty()):
			list.add_item(item["name"], item["icon"])

func things_compare(a, b):
	return items.items[a]["name"] < items.items[b]["name"]

func _on_sort_button_pressed():
	# todo: sorting is done twice
	list.sort_items_by_text()
	game.mgmt.player.inventory.things.sort_custom(self, "things_compare")

func _on_all_pressed():
	update_inventory()

func _on_weapons_pressed():
	update_inventory("weapon")

func _on_armor_pressed():
	update_inventory("armor")

func _on_consumables_pressed():
	update_inventory("consumable")

func _on_tokens_pressed():
	update_inventory("token")

func _on_list_item_activated(index):
	game.mgmt.player.interaction.consume(game.mgmt.player.inventory.things[index])
	list.remove_item(index)
