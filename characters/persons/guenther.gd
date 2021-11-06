extends abstract_person

class_name guenther_person

static func id() -> String:
	return "guenther"

func _init():
	data = {
		"dialogue": {
			"name": "Günther",
			"gender": "male",
			"relations": {
				"filz": 2,
				"vladimir": -1,
				"gerhard": 2,
				"gress": 2
			}
		},
		"stats": {
			"dead": true,
			"undead": true,
			"focus": 100.0
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"skills": ["base_fire", "base_darkness", "taint_life", "become_undead"],
			#"spell_slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.5, 0, 0.5)
		}
	}
