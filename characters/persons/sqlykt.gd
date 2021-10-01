extends abstract_person

class_name sqlykt_person

static func id() -> String:
	return "sqlykt"

func _init():
	data = {
		"dialogue": {
			"name": "Sqlykt",
			"gender": "ocelot"
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.3, 0.3, 0.3)
		},
	}
