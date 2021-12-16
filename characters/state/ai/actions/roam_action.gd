extends abstract_action

static func precondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.talking

static func postcondition_mask() -> int:
	return 0

static func cost() -> float:
	return 0.75

func get_range_state() -> int:
	choose_target()
	return range_state.out_of_range

func choose_target():
	target = Spatial.new()
	game.levels.current_level.add_child(target)
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	if(nav):
		var destination: Vector3 = Vector3(rand_range(-1, 1), 0, rand_range(-1, 1))
		target.global_transform.origin = nav.get_closest_point(pawn.global_transform.origin + 10 * destination)

func do(_delta: float) -> int:
	return do_state.success
