class_name abstract_level

var data: Dictionary = {}

static func id() -> String:
	errors.debug_assert(false) #,"should not be called")
	return ""

func is_in_death_realm() -> bool:
	errors.debug_assert(false) #,"should not be called")
	return false

func _boxes() -> Dictionary:
	return {}

func add_data(added_data: Dictionary):
	for x in added_data:
		if(data.has(x)):
			errors.debug_output("overwriting level data \"" + x + "\" in level: " + id())
		data[x] = added_data[x]

func scene_path() -> String:
	# TODO: remove
	errors.debug_assert(false) #,"should not be called")
	return ""

# no need to implement for subclasses
func get_box_content(box_id: String) -> Array:
	if(!data.has("boxes")):
		data["boxes"] = _boxes()
	errors.debug_assert(data["boxes"].has(box_id)) #,"no content for box " + box_id + " defined in " + id())
	return data["boxes"][box_id]

func set_box_content(box_id: String, content: Array):
	errors.debug_assert(_boxes().has(box_id)) #,"can not set content for box " + box_id + " defined in " + id())
	data["boxes"][box_id] = content
