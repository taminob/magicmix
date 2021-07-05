extends Node

const full = 10000
const spell_icons_path = "res://ui/icons/spells/"
const spell_scenes_path = "res://spells/"
const spell_anims_path = "res://spells/"

func get_spell(id: String) -> Dictionary:
	return spells.get(id, {})

func get_combinations(spell: Dictionary) -> Array:
	return spell.get("combinations", [])

func get_spell_name(spell: Dictionary) -> String:
	return spell.get("name", "")

func get_description(spell: Dictionary) -> String:
	return spell.get("description", "")

func get_category(spell: Dictionary) -> String:
	return spell.get("category", "")

# target: "self" or "target"
func get_focus(spell: Dictionary, target_string: String, per_second: bool=false) -> float:
	var x = spell.get(target_string, null)
	if(x == null):
		return 0.0
	if(per_second):
		return x.get("focus_per_second", 0.0)
	else:
		return x.get("focus", 0.0)

# target: "self" or "target"
func get_pain(spell: Dictionary, target_string: String, per_second: bool=false) -> float:
	var x = spell.get(target_string, null)
	if(x == null):
		return 0.0
	if(per_second):
		return x.get("pain_per_second", 0.0)
	else:
		return x.get("pain", 0.0)

func get_duration(spell: Dictionary) -> float:
	return spell.get("duration", 0.0)

func get_range(spell: Dictionary) -> float:
	return spell.get("range", 0.0)

func get_icon(spell: Dictionary) -> PackedScene:
	return spell.get("icon", load(spell_icons_path + "../empty_slot_frame-512.png"))

func get_anim(spell: Dictionary) -> String:
	return spell.get("anim", "")

func get_scene(spell: Dictionary) -> PackedScene:
	return spell.get("scene", null)

var spells = {
	"": {
		"name": "Do Nothing",
		"description": "Lose yourself in boredom!",
		"self": {
			"focus": -5
		},
		"anim": ""
	},
	"heal": {
		"combinations": [{
			"target": "self",
			"type": "defense",
			"elements": ["life"]
		}],
		"name": "Heal",
		"description": "Heal yourself for a bit!",
		"category": "heal",
		"self": {
			"focus": -10,
			"pain": -30,
		},
		"icon": load(spell_icons_path + "circle-512.png"),
		"anim": ""
	},
	"blood_sacrifice": {
		"combinations": [{
			"target": "self",
			"type": "defense",
			"elements": ["life", "life", "darkness"]
		}],
		"name": "Blood Sacrifice",
		"description": "Sacrifice your own life (or an innocent creature) to revive the nearest ally!",
		"category": "blood",
		"self": {
			"pain": 0#full
		},
		"target": {
			"pain": 0#-full
		},
		"duration": 0.5,
		"range": 10, # todo: calc/tune actual range
		"icon": load(spell_icons_path + "self_dark-512.png"),
		"anim": "",
		"scene": load(spell_scenes_path + "blood/blood_sacrifice.tscn")
	},
	"fire_storm": {
		"combinations": [{
			"target": "area",
			"type": "attack",
			"elements": ["fire", "fire", "darkness"]
		}],
		"name": "Fire Storm",
		"description": "Summon a huge fire storm and burn your foes!",
		"category": "fire",
		"self": {
			"focus_per_second": -5,
			"focus": -30
		},
		"target": {
			"focus_per_second": -5,
			"pain_per_second": 15
		},
		"duration": 5,
		"range": 10,
		"icon": load(spell_icons_path + "magma-512.png"),
		"anim": "",
		"scene": load(spell_scenes_path + "fire/fire_storm.tscn")
	},
	"fire_ring": {
		"combinations": [{
			"target": "area",
			"type": "defense",
			"elements": ["fire", "fire", "darkness"]
		}],
		"name": "Fire Ring",
		"description": "Summon a ring of fire to protect yourself!",
		"category": "fire",
		"self": {
			"focus_per_second": -5,
			"focus": -5
		},
		"target": {
			"focus_per_second": -10,
			"pain": 10,
			"pain_per_second": 1
		},
		"duration": 25,
		"range": 5,
		"icon": load(spell_icons_path + "fire_ring-512.png"),
		"anim": "",
		"scene": load(spell_scenes_path + "fire/fire_ring.tscn")
	},
	"blood_storm": {
		"combinations": [{
			"target": "area",
			"type": "attack",
			"elements": ["fire", "life", "darkness"]
		}],
		"name": "Blood Storm",
		"description": "Sacrifice a part of yourself to summon a deadly storm!",
		"category": "blood",
		"self": {
			"focus_per_second": -15,
			"focus": -20,
			"pain_per_second": 10,
			"pain": 20
		},
		"target": {
			"focus_per_second": -5,
			"pain_per_second": 40
		},
		"duration": 5,
		"range": 10,
		"icon": load(spell_icons_path + "blood_storm-512.png"),
		"anim": "",
		"scene": load(spell_scenes_path + "blood/blood_storm.tscn")
	}
}
