extends abstract_person

class_name mary_person

static func id() -> String:
	return "mary"

func _init():
	data = {
		"dialogue": {
			"name": "Mary",
			"description": "Happy Herbalist",
			"background": "Always smiling and greeting, she warms the heart of friend and foe.",
			"gender": "female",
			"relations": {
				"hans": 1,
				"vladimir": 2
			}
		},
		"experience": {
			"intelligence": 60,
			"strength": 25,
			"sturdiness": 90,
			"concentration": 125,
			"endurance": 150
		},
		"inventory": {
			"spells": ["fire_ball", "fire_ring", "blood_sacrifice", "heal", "blood_storm"],
		},
		"stats": {
			"focus": 100,
			"pain": 30
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0, 0.8, 0)
		},
	}
