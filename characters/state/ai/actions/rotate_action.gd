extends action

static func precondition() -> int:
	return !planner.knowledge.enemy_in_sight

static func postcondition() -> int:
	return planner.knowledge.ally_in_sight | planner.knowledge.enemy_in_sight

func get_range_state() -> int:
	return range_state.no_range_required

func do():
	var location = target.global_transform.origin
	pawn.look_at(Vector3(location.x, pawn.global_transform.origin.y, location.z), Vector3.UP)
