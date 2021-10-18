extends abstract_person

class_name gerhard_person

static func id() -> String:
	return "gerhard"

func _init():
	data = {
		"dialogue": {
			"name": "Gerhard",
			"gender": "male",
			"relations": {
				"guenther": 2,
				"gress": 2
			}
		},
		"experience": {
			"intelligence": 100,
			"strength": 100,
			"sturdiness": 100,
			"concentration": 100,
			"endurance": 100
		},
		"stats": {
			"dead": true
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(1, 1, 0)
		},
	}