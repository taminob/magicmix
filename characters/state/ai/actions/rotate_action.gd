extends abstract_action

static func precondition() -> int:
	return 0

static func postcondition() -> int:
	return planner.knowledge.facing_target

static func precondition_mask() -> int:
	return planner.knowledge.facing_target

static func postcondition_mask() -> int:
	return planner.knowledge.facing_target

func get_range_state() -> int:
	return range_state.no_range_required

func choose_target():
	# todo: better target choice
	target = pawn.ai.brain.get_any_enemy()

func do() -> bool:
	pawn.face_target(target)
	return true
