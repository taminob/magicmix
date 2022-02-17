extends abstract_person

class_name hans_person

static func id() -> String:
	return "hans"

func _init():
	data = {
		"dialogue": {
			"name": "Hans",
			"description": "Cunning Craftsman",
			"background": "Although sometimes taking more coins than he should, he is a talented craftsman.",
			"gender": "male",
			"job": "craftsman",
			"relations": {
				"vladimir": -2
			}
		},
		"experience": {
			"intelligence": 60,
			"strength": 30,
			"sturdiness": 250,
			"concentration": 600,
			"endurance": 100
		},
		"stats": {
			"focus": 70
		},
		"inventory": {
			"spells": ["fire_ball", "fire_ring", "fire_storm", "blood_sacrifice", "heal", "blood_storm", "blood_heal"],
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.45, 0, 0)
		},
	}
