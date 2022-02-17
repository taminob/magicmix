extends abstract_person

class_name guenther_person

static func id() -> String:
	return "guenther"

func _init():
	data = {
		"dialogue": {
			"name": "Günther",
			"description": "Crafty Captain",
			"background": "Still missing the sea at times, he has started a new life at land following his brothers to new lands.",
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
			"intelligence": 20,
			"strength": 70,
			"sturdiness": 650,
			"concentration": 100,
			"endurance": 250
		},
		"inventory": {
			"skills": ["base_fire", "base_darkness", "taint_life", "become_undead"],
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.5, 0, 0.5)
		}
	}
