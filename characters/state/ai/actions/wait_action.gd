extends abstract_action

static func precondition() -> int:
	return 0

static func postcondition() -> int:
	return 0

func get_range_state() -> int:
	return range_state.no_range_required

func do() -> bool:
	return true
