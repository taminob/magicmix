extends abstract_person

class_name ice_mage_person

static func id() -> String:
	return "ice_mage"

func _init():
	data = {
		"dialogue": {
			"name": "Ice Mage",
			"description": "Ice Mage",
			"background": "Wife of the god mage.",
			"gender": "female",
			"job": "mage"
		},
		"experience": {
			"intelligence": 45,
			"strength": 55,
			"sturdiness": 900,
			"concentration": 250,
			"endurance": 500
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"spells": [""],
			"skills": ["base_life"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.2, 0.2, 0.3)
		},
	}
