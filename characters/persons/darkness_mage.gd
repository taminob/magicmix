extends abstract_person

class_name darkness_mage_person

static func id() -> String:
	return "darkness_mage"

func _init():
	data = {
		"dialogue": {
			"name": "Darkness Mage",
			"description": "Darkness Mage",
			"background": "Advisor of the god mage.",
			"gender": "female",
			"job": "mage"
		},
		"experience": {
			"intelligence": 80,
			"strength": 30,
			"sturdiness": 500,
			"concentration": 900,
			"endurance": 200
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"skills": ["base_darkness"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0, 0, 0)
		},
	}
