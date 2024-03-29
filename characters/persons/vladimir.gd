extends abstract_person

class_name vladimir_person

static func id() -> String:
	return "vladimir"

func _init():
	data = {
		"dialogue": {
			"name": "Vlad",
			"description": "Generous Guard",
			"background": "Of a good-hearted nature, he always helps and takes good care of the towns outlaws.",
			"gender": "male",
			"relations": {
				"hans": -2,
				"filz": -1,
				"mary": 2
			},
			"job": "guard",
		},
		"experience": {
			"intelligence": 30,
			"strength": 65,
			"sturdiness": 150,
			"concentration": 125,
			"endurance": 100
		},
		"inventory": {
			"skills": ["base_fire", "base_ice", "element_shield"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.5, 0.5, 1)
		},
	}
