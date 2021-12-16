extends abstract_person

class_name fire_mage_person

static func id() -> String:
	return "fire_mage"

func _init():
	data = {
		"dialogue": {
			"name": "Fire Mage",
			"description": "Fire Mage",
			"background": "Left hand of the god mage.",
			"gender": "male",
			"job": "mage"
		},
		"experience": {
			"intelligence": 10,
			"strength": 3,
			"sturdiness": 5,
			"concentration": 9,
			"endurance": 2
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"spells": ["fire_storm", "heal"],
			#"spell_slots": ["heal", "fire_storm", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.3, 0.2, 0.2)
		},
	}
