extends abstract_action

const IMPORTANCE: float = 0.95

static func _spell_id() -> String:
	return heal_spell.id()

static func score(pawn: CharacterBody3D) -> Dictionary:
	var score: float = 0.0
	if(!pawn.stats.dead && !pawn.stats.undead):
		if(pawn.skills.can_cast(_spell_id())):
			var focus: float = pawn.stats.focus_percentage()
			var pain: float = pow(pawn.stats.pain_percentage(), 0.5)
			score = focus * pain * IMPORTANCE
	return {
		"score": score
	}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
