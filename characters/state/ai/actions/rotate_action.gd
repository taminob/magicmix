extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new()

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new(0, 0, 0, 0, planner.knowledge_mask.facing_target)

static func precondition_mask() -> int:
	return planner.knowledge_mask.facing_target

static func postcondition_mask() -> int:
	return planner.knowledge_mask.facing_target

static func cost() -> float:
	return 0.25

func get_range_state() -> int:
	return range_state.no_range_required

func choose_target():
	# todo: better target choice
	target = pawn.ai.brain.get_any_enemy()

func do() -> bool:
	pawn.face_target(target)
	return true
