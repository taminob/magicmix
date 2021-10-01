extends abstract_person

class_name sqlay_person

static func id() -> String:
	return "sqlay"

func _init():
	data = {
		"dialogue": {
			"name": "Sqlay",
			"gender": "ocelot"
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
			"spells": ["blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.5, 0.5, 0.5)
		},
	}
