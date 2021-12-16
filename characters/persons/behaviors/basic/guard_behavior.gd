extends abstract_behavior

func goals(pawn: KinematicBody) -> Array:
	var patrol_goal: ai_planner.goal = ai_planner.goal.new(ai_planner.knowledge.new(), ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.enemy_in_sight)
	patrol_goal.requirements.values[ai_planner.value.pain] = pawn.stats.max_pain() * 0.1
	patrol_goal.requirements.flags[ai_planner.flag.enemy_in_sight] = true
	return [patrol_goal]

func idle_action(pawn: KinematicBody) -> abstract_action:
	return load("res://characters/state/ai/actions/roam_action.gd").new()

func actions(pawn: KinematicBody) -> Array:
	return .actions(pawn)
