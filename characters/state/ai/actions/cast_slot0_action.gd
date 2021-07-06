extends action

const CAST_SLOT: int = 0

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

static func precondition() -> int:
	return planner.knowledge.high_focus

static func postcondition() -> int:
	return planner.knowledge.low_focus | planner.knowledge.enemy_damaged

func get_range_state() -> int:
	var spell_range = spells.get_range(spells.get_spell(pawn.inventory.get_skill_slot(CAST_SLOT)))
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do():
	pawn.skills.cast_slot(CAST_SLOT)
