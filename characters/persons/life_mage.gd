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
			"skills": ["base_life"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(1, 1, 1)
		},
	}
