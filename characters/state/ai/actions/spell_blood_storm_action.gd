extends abstract_action

const SPELL_NAME = "blood_storm"

static func precondition() -> planner.knowledge:
	var spell = skill_data.spells[SPELL_NAME]
	return planner.knowledge.new(spell.self_pain() + spell.self_pain_per_second(), -spell.self_focus() - spell.self_focus_per_second(), planner.knowledge_mask.enemy_in_near)

static func postcondition() -> planner.knowledge:
	var spell = skill_data.spells[SPELL_NAME]
	return planner.knowledge.new(spell.self_pain(), spell.self_focus(), planner.knowledge_mask.enemy_damaged)

static func precondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.focus_toggle | planner.knowledge_mask.pain | planner.knowledge_mask.enemy_in_near

static func postcondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.pain | planner.knowledge_mask.enemy_damaged

func choose_target():
	target = pawn.ai.brain.get_any_enemy()

func get_range_state() -> int:
	var spell_range = skill_data.spells[SPELL_NAME].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.face_target(target)
	pawn.skills.cast(SPELL_NAME)
	return true
