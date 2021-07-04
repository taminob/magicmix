extends action

static func precondition(_know: Dictionary) -> float:
	return action.PERFECT_SCORE

static func postcondition(know: Dictionary) -> Dictionary:
	return know

func do(_delta: float, know: Dictionary):
	know["pawn"].move.input_direction = Vector3.ZERO
