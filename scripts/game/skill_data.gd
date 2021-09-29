extends Node

# todo? auto register spells/skills using ProjectSettings.get_setting("_global_script_classes") and filter for all with "base": "abstract_skill"/"abstract_spell"

# warning-ignore:unused_class_variable
var spells = {
	do_nothing_spell.id(): do_nothing_spell.new(),
	heal_spell.id(): heal_spell.new(),
	blood_heal_spell.id(): blood_heal_spell.new(),
	blood_sacrifice_spell.id(): blood_sacrifice_spell.new(),
	blood_storm_spell.id(): blood_storm_spell.new(),
	fire_ball_spell.id(): fire_ball_spell.new(),
	fire_ring_spell.id(): fire_ring_spell.new(),
	fire_storm_spell.id(): fire_storm_spell.new(),
}

# warning-ignore:unused_class_variable
var skills = {
	do_nothing_skill.id(): do_nothing_skill.new(),
	base_life_skill.id(): base_life_skill.new(),
	invert_gravity_skill.id(): invert_gravity_skill.new(),
	base_darkness_skill.id(): base_darkness_skill.new(),
	base_fire_skill.id(): base_fire_skill.new(),
	shield_fire_skill.id(): shield_fire_skill.new(),
	focus_sprint_skill.id(): focus_sprint_skill.new(),
}
