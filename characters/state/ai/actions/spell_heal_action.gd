extends abstract_action

static func spell_id() -> String:
	return heal_spell.id()

static func precondition() -> ai_planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return ai_planner.knowledge.new(0, -spell.self_focus())

static func postcondition() -> ai_planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return ai_planner.knowledge.new(spell.self_pain(), spell.self_focus())

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.focus | ai_planner.knowledge_mask.focus_toggle

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.focus | ai_planner.knowledge_mask.pain

static func cost() -> float:
	return 0.6

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.skills.cast_spell(spell_id())
	return do_state.success
