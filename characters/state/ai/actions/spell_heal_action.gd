extends abstract_action

const IMPORTANCE: float = 0.95

static func score(pawn: KinematicBody) -> Dictionary:
	var score: float
	if(pawn.stats.dead || pawn.stats.undead):
		score = 0.0
	else:
		var focus: float = pawn.stats.focus_percentage()
		var pain: float = pow(pawn.stats.pain_percentage(), 0.5)
		score = focus * pain * IMPORTANCE
	return {
		"score": score
	}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.skills.cast_spell(heal_spell.id())
	return do_state.success
