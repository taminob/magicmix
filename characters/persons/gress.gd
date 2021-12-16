extends abstract_person

class_name gress_person

static func id() -> String:
	return "gress"

func _init():
	data = {
		"dialogue": {
			"name": "Gress",
			"description": "Bored Bard",
			"background": "Rarely motivated, he is bored of live itself and sleeps more than playing his instrument.",
			"gender": "male",
			"relations": {
				"hans": 2,
				"vladimir": -1,
				"gerhard": 2,
				"guenther": 2
			}
		},
		"stats": {
			"dead": true
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"spells": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			#"spell_slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0, 0, 1)
		}
	}
