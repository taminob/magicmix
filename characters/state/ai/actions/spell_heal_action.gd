extends abstract_action

static func spell_id() -> String:
	return heal_spell.id()

static func precondition() -> planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return planner.knowledge.new(0, -spell.self_focus())

static func postcondition() -> planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return planner.knowledge.new(spell.self_pain(), spell.self_focus())

static func precondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.focus_toggle

static func postcondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.pain

func get_range_state() -> int:
	if(!game.is_valid(target)):
		return range_state.unreachable
	var spell_range = skill_data.spells[spell_id()].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.skills.cast_spell(spell_id())
	return true
