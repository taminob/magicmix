extends abstract_action

static func precondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new(80, 0)

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.focus | ai_planner.knowledge_mask.focus_toggle

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.enemy_in_near

static func cost() -> float:
	return 0.75

func get_range_state() -> int:
	choose_target()
	if(!pawn.ai.brain.is_any(ai_mind.body_type.enemy)):
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
