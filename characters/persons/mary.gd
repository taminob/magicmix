extends abstract_person

class_name mary_person

static func id() -> String:
	return "mary"

func _init():
	data = {
		"dialogue": {
			"name": "Mary",
			"gender": "female",
			"relations": {
				"hans": 1,
				"vladimir": 2
			}
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"spells": ["fire_ball", "fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			#"spell_slots": ["fire_ball", "fire_ring", "", "", "heal"]
		},
		"stats": {
			"focus": 100,
			"pain": 30
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0, 0.8, 0)
		},
	}
