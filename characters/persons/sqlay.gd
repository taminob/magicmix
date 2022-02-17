extends abstract_person

class_name sqlay_person

static func id() -> String:
	return "sqlay"

func _init():
	data = {
		"dialogue": {
			"name": "Sqlay",
			"description": "Offending Ocelot",
			"background": "His tongue has cost him his life.",
			"gender": "ocelot"
		},
		"stats": {
			"dead": false # TODO (DEBUG): true
		},
		"experience": {
			"intelligence": 10,
			"strength": 10,
			"sturdiness": 100,
			"concentration": 100,
			"endurance": 100
		},
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.5, 0.5, 0.5)
		},
	}
