extends abstract_level

static func id() -> String:
	return "arena"

func is_in_death_realm() -> bool:
	return false

func scene_path() -> String:
	return "res://world/levels/arena/level.tscn"