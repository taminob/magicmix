extends abstract_level

static func id() -> String:
	return "arena"

func is_in_death_realm() -> bool:
	return data.get("debug_level_data", {}).get("death_realm", false)

func scene_path() -> String:
	return data["debug_level_data"].get("path", "")
