extends abstract_action

static func precondition() -> int:
	return planner.knowledge.high_pain

static func postcondition() -> int:
	return 0

static func precondition_mask() -> int:
	return planner.knowledge.high_pain

static func postcondition_mask() -> int:
	return planner.knowledge.enemy_in_near

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
