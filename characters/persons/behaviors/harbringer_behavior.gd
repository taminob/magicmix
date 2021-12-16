extends abstract_behavior

func goals(pawn: KinematicBody) -> Array:
	var fight_goal = ai_planner.goal.new(ai_planner.knowledge.new(), ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.enemy_damaged)
	fight_goal.requirements.values[ai_planner.value.pain] = pawn.stats.max_pain() * 0.9
	fight_goal.requirements.flags[ai_planner.flag.enemy_damaged] = true
	return [fight_goal]

func idle_action(pawn: KinematicBody) -> abstract_action:
	return load("res://characters/state/ai/actions/wait_action.gd").new()

func actions(pawn: KinematicBody) -> Array:
	return .actions(pawn)
