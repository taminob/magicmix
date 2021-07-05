extends action

static func precondition(_know: Dictionary) -> float:
	return action.PERFECT_SCORE

static func postcondition(know: Dictionary) -> Dictionary:
	# todo
	return {
		"distance": know["distance"],
	}

func do(_delta: float, know: Dictionary):
	var pawn = know["pawn"]
	var location = know["target"].global_transform.origin
	pawn.look_at(Vector3(location.x, pawn.global_transform.origin.y, location.z), Vector3.UP)
