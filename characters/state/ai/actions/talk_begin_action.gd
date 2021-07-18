extends abstract_action

static func precondition() -> int:
	return planner.knowledge.ally_in_sight

static func postcondition() -> int:
	return planner.knowledge.talking

static func precondition_mask() -> int:
	return planner.knowledge.ally_in_sight | planner.knowledge.talking

static func postcondition_mask() -> int:
	return planner.knowledge.talking

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
