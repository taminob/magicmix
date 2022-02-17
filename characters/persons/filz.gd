extends abstract_person

class_name filz_person

static func id() -> String:
	return "filz"

func _init():
	data = {
		"dialogue": {
			"name": "Filz",
			"description": "Thirsty Thief",
			"background": "He is a kleptomaniacal drunkard who tends to spend his free time in either a brothel or a prison cell.",
			"gender": "male",
			"job": "thief",
		},
		"experience": {
			"intelligence": 10,
			"strength": 50,
			"sturdiness": 150,
			"concentration": 100,
			"endurance": 200
		},
		"stats": {
			"pain": 45
		},
		"inventory": {
			"spells": ["fire_storm", "heal"],
			#"spell_slots": ["heal", "fire_storm", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/mage/body.tscn",
			"color": Color(0.8, 0.6, 0.1)
		},
	}
