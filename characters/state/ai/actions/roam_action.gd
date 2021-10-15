extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new()

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new()

static func precondition_mask() -> int:
	return planner.knowledge_mask.talking

static func postcondition_mask() -> int:
	return 0

func get_range_state() -> int:
	choose_target()
	return range_state.out_of_range

func choose_target():
	target = Spatial.new()
	game.levels.current_level.add_child(target)
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	if(nav):
		var destination: Vector3 = Vector3(rand_range(-1, 1), 0, rand_range(-1, 1))
		target.global_transform.origin = nav.get_closest_point(pawn.global_transform.origin + 50 * destination)

func do() -> bool:
	return true
