extends abstract_level

static func id() -> String:
	return "town"

func is_in_death_realm() -> bool:
	return false

func _boxes() -> Dictionary:
	return {
		"garden_box1": ["deadly_poison", "deadly_poison"],
		"garden_box2": ["dark_token", "fire_token"],
		"garden_box3": ["dark_potion", "dark_potion"],
	}

func scene_path() -> String:
	return "res://world/levels/town/level.tscn"
