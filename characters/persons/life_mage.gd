extends abstract_person

class_name life_mage_person

static func id() -> String:
	return "life_mage"

func _init():
	data = {
		"dialogue": {
			"name": "Life Mage",
			"description": "Life Mage",
			"background": "Advisor of the god mage.",
			"gender": "female",
			"job": "mage"
		},
		"experience": {
			"intelligence": 75,
			"strength": 25,
			"sturdiness": 250,
			"concentration": 1500,
			"endurance": 650
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"skills": ["base_life"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(1, 1, 1)
		},
	}
