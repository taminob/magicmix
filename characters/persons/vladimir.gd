extends abstract_person

class_name vladimir_person

static func id() -> String:
	return "vladimir"

func _init():
	data = {
		"dialogue": {
			"name": "Vlad",
			"gender": "male",
			"relations": {
				"hans": -2,
				"filz": -1,
				"mary": 2
			},
			"job": "guard"
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"spells": ["blood_sacrifice", "blood_storm"],
			"skills": ["base_fire", "base_life", "base_ice", "base_darkness"]
			#"spell_slots": ["fire_ring", "heal", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.5, 0.5, 1)
		},
	}
