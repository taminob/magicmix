extends abstract_action

static func precondition() -> planner.knowledge:
	return planner.knowledge.new(80, 0)

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new()

static func precondition_mask() -> int:
	return planner.knowledge_mask.pain | planner.knowledge_mask.focus | planner.knowledge_mask.focus_toggle

static func postcondition_mask() -> int:
	return planner.knowledge_mask.enemy_in_near

func get_range_state() -> int:
	choose_target()
	if(pawn.ai.brain.enemies_out_of_sight.empty()):
		return range_state.in_range
	return range_state.out_of_range

func choose_target():
	target = Spatial.new()
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	var nearest_enemy = pawn.ai.brain.get_nearest_enemy()
	if(nav && nearest_enemy):
		target.translation = nav.get_closest_point(pawn.translation - 10 * pawn.translation.direction_to(nearest_enemy.translation))

func do() -> bool:
	return true
