extends abstract_level

static func id() -> String:
	return "death_realm"

func is_in_death_realm() -> bool:
	return true

func scene_path() -> String:
	return "res://world/levels/death_realm/level.tscn"
