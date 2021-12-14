class_name abstract_behavior

func goals(pawn: KinematicBody) -> Array:
	var goals: Array = []
	if(!pawn.stats.undead && !pawn.stats.dead):
		var survive_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain)
		survive_goal.requirements.values[planner.value.pain] = max(pawn.stats.pain - 10, 5) # todo? better requirements
		goals.push_back(survive_goal)
	var fight_goal: planner.goal
	if(pawn.stats.undead || pawn.stats.dead):
		fight_goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.enemy_damaged)
	else:
		fight_goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_damaged)
		fight_goal.requirements.values[planner.value.pain] = pawn.stats.max_pain() * 0.9
	fight_goal.requirements.flags[planner.flag.enemy_damaged] = true
	goals.push_back(fight_goal)
	var talk_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.talking)
	talk_goal.requirements.flags[planner.flag.talking] = true
	for x in pawn.dialogue.data.wants_to_talk_to:
		if(pawn.ai.brain.is_in_sight_by_id(x)):
			goals.push_back(talk_goal)
			break
	if(pawn.dialogue.job == "guard"):
		var patrol_goal: planner.goal = planner.goal.new(planner.knowledge.new(), planner.knowledge_mask.pain | planner.knowledge_mask.enemy_in_sight)
		patrol_goal.requirements.values[planner.value.pain] = pawn.stats.max_pain() * 0.1
		patrol_goal.requirements.flags[planner.flag.enemy_in_sight] = true
		goals.push_back(patrol_goal)
	return goals

func idle_action(pawn: KinematicBody) -> abstract_action:
	var idle_action: abstract_action
	match pawn.dialogue.job:
		"thief":
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
		"guard":
			idle_action = load("res://characters/state/ai/actions/roam_action.gd").new()
		"mage":
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
		_:
			idle_action = load("res://characters/state/ai/actions/wait_action.gd").new()
	idle_action.init(pawn)
	return idle_action

func actions(_pawn: KinematicBody) -> Array:
	return [
		load("res://characters/state/ai/actions/wait_action.gd"),
		load("res://characters/state/ai/actions/talk_begin_action.gd"),
		load("res://characters/state/ai/actions/roam_action.gd"),
		load("res://characters/state/ai/actions/rotate_action.gd"),
		load("res://characters/state/ai/actions/flee_action.gd"),
		load("res://characters/state/ai/actions/behavior_tree_action.gd"),
#		load("res://characters/state/ai/actions/spell_heal_action.gd"),
#		load("res://characters/state/ai/actions/spell_element_shield_action.gd"),
#		load("res://characters/state/ai/actions/spell_fire_ring_action.gd"),
#		load("res://characters/state/ai/actions/spell_fire_ball_action.gd"),
	]
