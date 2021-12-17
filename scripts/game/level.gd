class_name abstract_level

var data: Dictionary

static func id() -> String:
	errors.debug_assert(false, "should not be called")
	return ""

func is_in_death_realm() -> bool:
	errors.debug_output("should not be called outside of debugging (fallback is_in_death_realm in abstract_level)!")
	return data["level_data"].get("death_realm", false)

func _boxes() -> Dictionary:
	return {}

func scene_path() -> String:
	errors.debug_output("should not be called outside of debugging (fallback scene_path in abstract_level)!")
	return data["level_data"].get("path", "")

# no need to implement for subclasses
func get_box_content(box_id: String) -> Array:
	errors.debug_assert(_boxes().has(box_id), "no content for box " + box_id + " defined in " + id())
	return _boxes().get(box_id, [])
