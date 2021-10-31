extends Node

# todo? auto register spells/skills using ProjectSettings.get_setting("_global_script_classes") and filter for all with "base": "abstract_skill"/"abstract_spell"

# warning-ignore:unused_class_variable
var spells = {
	do_nothing_spell.id(): do_nothing_spell.new(),
	element_shield_spell.id(): element_shield_spell.new(),
	heal_spell.id(): heal_spell.new(),
	invert_gravity_spell.id(): invert_gravity_spell.new(),
	summon_minion_spell.id(): summon_minion_spell.new(),
	blood_heal_spell.id(): blood_heal_spell.new(),
	blood_sacrifice_spell.id(): blood_sacrifice_spell.new(),
	blood_storm_spell.id(): blood_storm_spell.new(),
	fire_ball_spell.id(): fire_ball_spell.new(),
	fire_ring_spell.id(): fire_ring_spell.new(),
	fire_storm_spell.id(): fire_storm_spell.new(),
	ice_ball_spell.id(): ice_ball_spell.new(),
	ice_wave_spell.id(): ice_wave_spell.new(),
}

# warning-ignore:unused_class_variable
var skills = {
	do_nothing_skill.id(): do_nothing_skill.new(),
	base_life_skill.id(): base_life_skill.new(),
	element_shield_skill.id(): element_shield_skill.new(),
	invert_gravity_skill.id(): invert_gravity_skill.new(),
	base_darkness_skill.id(): base_darkness_skill.new(),
	element_embrace_skill.id(): element_embrace_skill.new(),
	taint_fire_skill.id(): taint_fire_skill.new(),
	taint_ice_skill.id(): taint_ice_skill.new(),
	taint_life_skill.id(): taint_life_skill.new(),
	become_undead_skill.id(): become_undead_skill.new(),
	base_fire_skill.id(): base_fire_skill.new(),
	focus_sprint_skill.id(): focus_sprint_skill.new(),
	shield_sprint_skill.id(): shield_sprint_skill.new(),
	master_fire_skill.id(): master_fire_skill.new(),
	base_ice_skill.id(): base_ice_skill.new(),
	focus_stance_skill.id(): focus_stance_skill.new(),
}
