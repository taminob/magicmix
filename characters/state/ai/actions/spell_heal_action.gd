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

static func cost() -> float:
	return 0.6

func get_range_state() -> int:
	return range_state.no_range_required

func do() -> bool:
	pawn.skills.cast_spell(spell_id())
	return true
