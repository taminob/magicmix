extends abstract_person

class_name gerhard_person

static func id() -> String:
	return "gerhard"

func _init():
	data = {
		"dialogue": {
			"name": "Gerhard",
			"description": "Grinning Genius",
			"background": "Although always grinning like an idiot, he is a genius and the smartest of the three brothers.",
			"gender": "male",
			"relations": {
				"guenther": 2,
				"gress": 2
			}
		},
		"experience": {
			"intelligence": 100,
			"strength": 15,
			"sturdiness": 100,
			"concentration": 1000,
			"endurance": 100
		},
		"stats": {
			"dead": true
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(1, 1, 0)
		},
	}
