class_name abstract_person

static func id() -> String:
	errors.debug_assert(false, "abstract_person id should not be called")
	return ""

# warning-ignore:unused_class_variable
var data: Dictionary
