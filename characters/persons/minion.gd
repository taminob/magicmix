extends abstract_person

class_name minion_person

static func id() -> String:
	return "minion"

func _init():
	data = {
		"dialogue": {
			"name": "Minion",
			"job": "minion"
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"spells": ["fire_ball", "heal"],
			#"spell_slots": ["heal", "fire_storm", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/minion/body.tscn",
			"color": Color(0.1, 0.1, 0.1)
		},
	}
