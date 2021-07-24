extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new(0, 0, planner.knowledge_mask.ally_in_sight)

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new(0, 0, planner.knowledge_mask.talking)

static func precondition_mask() -> int:
	return planner.knowledge_mask.ally_in_sight | planner.knowledge_mask.talking

static func postcondition_mask() -> int:
	return planner.knowledge_mask.talking

func choose_target():
	target = pawn.ai.brain.get_any_ally()

func get_range_state() -> int:
	# todo: decide if based on distance or actual interaction target
	#if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= 2):
	if(pawn.interaction.interact_target == target):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.interaction.initiate_interact()
	return true
