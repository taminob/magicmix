extends abstract_person

class_name minion_person

static func id() -> String:
	return "minion"

func _init():
	data = {
		"dialogue": {
			"name": "Minion",
			"description": "Mindless Minion",
			"background": "A small summon which will fight against the enemies of its master.",
			"job": "minion"
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 25,
			"concentration": 50,
			"endurance": 1000
		},
		"inventory": {
			"spells": ["fire_ball", "ice_ball"],
		},
		"look": {
			"mesh_path": "res://characters/meshes/minion/body.tscn",
			"color": Color(0.1, 0.1, 0.1)
		},
	}
