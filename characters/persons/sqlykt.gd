extends abstract_person

class_name sqlykt_person

static func id() -> String:
	return "sqlykt"

func _init():
	data = {
		"dialogue": {
			"name": "Sqlykt",
			"description": "Outcast Ocelot",
			"background": "After his brother was killed, he was exiled from his home.",
			"gender": "ocelot"
		},
		"experience": {
			"intelligence": 10,
			"strength": 10,
			"sturdiness": 120,
			"concentration": 120,
			"endurance": 120
		},
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.3, 0.3, 0.3)
		},
	}
