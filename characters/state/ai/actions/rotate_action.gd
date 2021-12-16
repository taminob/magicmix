extends abstract_action

static func precondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new(0, 0, 0, 0, ai_planner.knowledge_mask.facing_target)

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.facing_target

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.facing_target

static func cost() -> float:
	return 0.25

func get_range_state() -> int:
	return range_state.no_range_required

func choose_target():
	# todo: better target choice
	target = pawn.ai.brain.get_any_enemy()

func do(_delta: float) -> int:
	pawn.face_target(target)
	return do_state.success
