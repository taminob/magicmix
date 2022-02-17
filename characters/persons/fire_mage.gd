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
			"intelligence": 25,
			"strength": 60,
			"sturdiness": 750,
			"concentration": 450,
			"endurance": 500
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"skills": ["base_fire"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.3, 0.2, 0.2)
		},
	}
