extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new(80, 0)

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new()

static func precondition_mask() -> int:
	return planner.knowledge_mask.pain | planner.knowledge_mask.focus | planner.knowledge_mask.focus_toggle

static func postcondition_mask() -> int:
	return planner.knowledge_mask.enemy_in_near

static func cost() -> float:
	return 0.75

func get_range_state() -> int:
	choose_target()
	if(pawn.ai.brain.enemies_out_of_sight.empty()):
		return range_state.in_range
	return range_state.out_of_range

func choose_target():
	target = Spatial.new()
	game.levels.current_level.add_child(target)
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	var nearest_enemy = pawn.ai.brain.get_nearest_enemy()
	if(nav && game.is_valid(nearest_enemy)):
		target.global_transform.origin = nav.get_closest_point(pawn.global_transform.origin - 10 * pawn.global_transform.origin.direction_to(nearest_enemy.global_transform.origin))

func do(_delta: float) -> int:
	return do_state.success
