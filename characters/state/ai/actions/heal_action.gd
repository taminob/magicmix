extends abstract_action

static func precondition() -> int:
	return planner.knowledge.high_pain# | planner.knowledge.high_focus # todo

static func postcondition() -> int:
	return planner.knowledge.low_pain# | planner.knowledge.low_focus # todo

static func precondition_mask() -> int:
	return planner.knowledge.high_pain | planner.knowledge.low_focus

static func postcondition_mask() -> int:
	return planner.knowledge.low_pain | planner.knowledge.high_pain | planner.knowledge.high_focus

func get_range_state() -> int:
	var spell_range = skill_data.spells["heal"].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do():
	pawn.skills.cast("heal")
