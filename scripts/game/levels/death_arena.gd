extends abstract_level

static func id() -> String:
	return "death_arena"

func _init():
	add_data({
		"minion_limit": 8
	})

func is_in_death_realm() -> bool:
	return true

func scene_path() -> String:
	return "res://world/levels/death_arena/level.tscn"
