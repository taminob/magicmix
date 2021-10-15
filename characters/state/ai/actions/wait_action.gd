extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new()

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new()

func get_range_state() -> int:
	return range_state.out_of_range

func do() -> bool:
	return true
