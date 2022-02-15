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
			"skills": ["base_darkness"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0, 0, 0)
		},
	}
