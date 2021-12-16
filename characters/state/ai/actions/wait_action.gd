extends abstract_action

static func precondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func precondition_mask() -> int:
	return 0

static func postcondition_mask() -> int:
	return 0

static func cost() -> float:
	return 0.01

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.repeat
