extends abstract_person

class_name harbringer_person

static func id() -> String:
	return "harbringer"

func _init():
	data = {
		"dialogue": {
			"name": "Harbringer",
			"description": "Harbringer",
			"background": "Bringer of doom to all his and his master's enemies.",
			"gender": "male",
			"job": "harbringer"
		},
		"experience": {
			"intelligence": 20,
			"strength": 20,
			"sturdiness": 20,
			"concentration": 20,
			"endurance": 20
		},
		"stats": {
			"focus": 100000
		},
		"inventory": {
			"skills": ["base_fire", "base_darkness", "taint_fire"],
			#"spell_slots": ["", "", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(1, 1, 1)
		},
	}
