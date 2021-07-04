extends action


static func precondition(know: Dictionary) -> float:
	var score: float = know["distance"]
	var interact_target = know["pawn"].interaction.interact_target
	if(score < 2 && interact_target == know["target"]):
		return action.PERFECT_SCORE
	return score

static func postcondition(_know: Dictionary) -> Dictionary:
	return {
		"interacting": true
	}

func do(_delta: float, know: Dictionary):
	know["pawn"].interaction.initiate_interact()
