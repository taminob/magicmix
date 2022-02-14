extends abstract_action

const IMPORTANCE: float = 0.05

static func score(pawn: KinematicBody) -> Dictionary:
	var score: float = 0.0
	var target: Spatial = null
	if(!pawn.dialogue.is_dialogue_active()):
		target = game.levels.get_spawn(pawn.name)
		if(target):
			score = IMPORTANCE
	return {
		"score": score,
		"target": target
	}

func get_range_state() -> int:
	if((pawn.global_transform.origin - target().global_transform.origin).abs() < Vector3(1, 1, 1)):
		return range_state.in_range
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.global_transform.basis = target().global_transform.basis
	return do_state.success
