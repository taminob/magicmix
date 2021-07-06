extends action

static func precondition() -> int:
	return 0

static func postcondition() -> int:
	return planner.knowledge.talking

func get_range_state() -> int:
	# todo: decide if based on distance or actual interaction target
	#if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= 2):
	if(pawn.interaction.interact_target == target):
		return range_state.in_range
	return range_state.out_of_range

func do():
	pawn.interaction.initiate_interact()
