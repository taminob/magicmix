extends abstract_person

class_name ice_mage_person

static func id() -> String:
	return "ice_mage"

func _init():
	data = {
		"dialogue": {
			"name": "Ice Mage",
			"gender": "female",
			"job": "mage"
		},
		"experience": {
			"intelligence": 7,
			"strength": 2,
			"sturdiness": 9,
			"concentration": 15,
			"endurance": 4
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"spells": ["heal"],
			#"spell_slots": ["heal", "", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.2, 0.2, 0.3)
		},
	}
