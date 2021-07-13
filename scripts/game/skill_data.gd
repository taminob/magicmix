extends Node

# warning-ignore:unused_class_variable
var spells = {
	"": do_nothing_spell.new(),
	"heal": heal_spell.new(),
	"blood_sacrifice": blood_sacrifice_spell.new(),
	"blood_heal": blood_heal_spell.new(),
	"fire_storm": fire_storm_spell.new(),
	"fire_ring": fire_ring_spell.new(),
	"blood_storm": blood_storm_spell.new()
}
