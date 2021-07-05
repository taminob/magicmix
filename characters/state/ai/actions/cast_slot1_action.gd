extends action

const CAST_SLOT: int = 1

static func _cast_data(pawn: character) -> Array:
	var spell = spells.get_spell(pawn.inventory.get_skill_slot(CAST_SLOT))
	var cast_data = []
	cast_data.push_back(spells.get_focus(spell, "self"))
	cast_data.push_back(spells.get_focus(spell, "self", true))
	cast_data.push_back(spells.get_pain(spell, "self"))
	return cast_data

static func _can_cast(pawn: character) -> bool:
	var data = _cast_data(pawn)
	return pawn.stats.focus + data[0] >= 0 && pawn.stats.focus + data[1] >= 0 && pawn.stats.pain + data[2] < pawn.stats.max_pain()

static func precondition(know: Dictionary) -> float:
	return int(_can_cast(know["pawn"])) * action.PERFECT_SCORE

static func postcondition(know: Dictionary) -> Dictionary:
	var pawn = know["pawn"]
	var data = _cast_data(pawn)
	var delta = 0.5
	return {
		"pain": pawn.stats.pain + data[2],
		"focus": pawn.stats.focus + data[0] + delta * data[1],
	}

func do(_delta: float, know: Dictionary):
	know["pawn"].skills.cast_slot(CAST_SLOT)
