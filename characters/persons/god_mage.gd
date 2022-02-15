extends abstract_person

class_name god_mage_person

static func id() -> String:
	return "god_mage"

func _init():
	data = {
		"dialogue": {
			"name": "God Mage",
			"description": "God Mage",
			"background": "Ruler of the realm.",
			"gender": "female",
			"job": "mage"
		},
		"experience": {
			"intelligence": 20,
			"strength": 20,
			"sturdiness": 20,
			"concentration": 20,
			"endurance": 20
		},
		"stats": {
			"focus": 100
		},
		"inventory": {
			"skills": ["base_fire", "base_ice", "base_darkness", "base_life"],
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0, 0, 0)
		},
	}
