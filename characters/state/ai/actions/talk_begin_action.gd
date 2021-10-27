extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new(0, 0, 0, 0, planner.knowledge_mask.ally_in_sight)

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new(0, 0, 0, 0, planner.knowledge_mask.talking)

static func precondition_mask() -> int:
	return planner.knowledge_mask.ally_in_sight | planner.knowledge_mask.talking

static func postcondition_mask() -> int:
	return planner.knowledge_mask.talking

static func cost() -> float:
	return 1.0

func choose_target():
	for x in pawn.dialogue.data.wants_to_talk_to:
		if(pawn.ai.brain.is_in_sight_by_id(x)):
			target = game.get_character(x)
			return

func get_range_state() -> int:
	if(!game.is_valid(target)):
		return range_state.unreachable
	# todo: decide if based on distance or actual interaction target
	#if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= 2):
	if(pawn.interaction.get_target() == target):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.interaction.initiate_interact()
	return true
