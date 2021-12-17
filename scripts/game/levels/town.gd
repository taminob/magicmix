extends abstract_level

static func id() -> String:
	return "town"

func is_in_death_realm() -> bool:
	return false

func scene_path() -> String:
	return "res://world/levels/town/level.tscn"
