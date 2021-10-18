extends abstract_person

class_name hans_person

static func id() -> String:
	return "hans"

func _init():
	data = {
		"dialogue": {
			"name": "Hans",
			"gender": "male",
			"job": "thief",
			"relations": {
				"vladimir": -2
			}
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"stats": {
			"focus": 70
		},
		"inventory": {
			"spells": ["fire_ball", "fire_ring", "fire_storm", "blood_sacrifice", "heal", "blood_storm", "blood_heal"],
			#"spell_slots": ["heal", "fire_ring", "fire_ball", "blood_storm", "blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.45, 0, 0)
		},
	}