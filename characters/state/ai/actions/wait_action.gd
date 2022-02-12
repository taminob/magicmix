extends abstract_action

static func score(_pawn: KinematicBody) -> Dictionary:
	return {
		"score": 0.0
	}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.success
