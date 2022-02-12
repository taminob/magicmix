class_name abstract_behavior

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
	idle_action.init(pawn, {"score": 0.0})
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
