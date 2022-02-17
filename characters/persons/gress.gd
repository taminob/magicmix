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
			"intelligence": 50,
			"strength": 40,
			"sturdiness": 300,
			"concentration": 500,
			"endurance": 300
		},
		"inventory": {
			"spells": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			#"spell_slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0, 0, 1)
		}
	}
