extends abstract_action

const CAST_SLOT: int = 1

static func _cast_data(pawn: character) -> Array:
	var spell: abstract_spell = skill_data.spells[pawn.inventory.get_skill_slot(CAST_SLOT)]
	var cast_data = []
	cast_data.push_back(spell.self_focus())
	cast_data.push_back(spell.self_focus_per_second())
	cast_data.push_back(spell.self_pain())
	return cast_data

static func _can_cast(pawn: character) -> bool:
	var data = _cast_data(pawn)
	return pawn.stats.focus + data[0] >= 0 && pawn.stats.focus + data[1] >= 0 && pawn.stats.pain + data[2] < pawn.stats.max_pain()

static func precondition() -> int:
	return planner.knowledge.high_focus | planner.knowledge.enemy_in_sight

static func postcondition() -> int:
	return planner.knowledge.low_focus | planner.knowledge.enemy_damaged

static func precondition_mask() -> int:
	return planner.knowledge.high_focus | planner.knowledge.low_focus | planner.knowledge.high_pain | planner.knowledge.enemy_in_sight

static func postcondition_mask() -> int:
	return planner.knowledge.low_focus | planner.knowledge.enemy_damaged

func choose_target():
	target = pawn.ai.brain.get_any_enemy()

func get_range_state() -> int:
	var spell_range = skill_data.spells[pawn.inventory.get_skill_slot(CAST_SLOT)].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.face_target(target)
	pawn.skills.cast_slot(CAST_SLOT)
	return true
