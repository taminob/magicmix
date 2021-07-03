extends Node

# warning-ignore:unused_class_variable
var characters = {
	"hans": {
		"dialogue": {
			"name": "Hans",
			"gender": "male"
		},
		"stats": {},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"move": {
			"translations": {}
		},
		"inventory": {
			"skills": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["heal", "fire_ring", "", "blood_storm", "blood_sacrifice"]
		},
		"skills": {},
		"look": {
			"mesh": "res://characters/meshes/patrol/body.tscn"
		}
	},
	"mary": {
		"dialogue": {
			"name": "Mary",
			"gender": "female",
			"dialogue": "res://characters/dialogue/mary/dialogue.gd",
			"current_dialogue": 0
		},
		"stats": {},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"move": {
			"translations": {}
		},
		"inventory": {
			"skills": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["fire_ring", "heal"]
		},
		"skills": {},
		"look": {
			"mesh": "res://characters/meshes/default/body.tscn"
		}
	},
	"guenther": {
		"dialogue": {
			"name": "Günther",
			"gender": "male",
			"dialogue": "res://characters/dialogue/guenther/dialogue.gd",
			"current_dialogue": 0
		},
		"stats": {
			"dead": true,
			"undead": true,
			"pain": 100.0
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"look": {
			"mesh": "res://characters/meshes/patrol/body.tscn"
		}
	},
	"vladimir": {
		"dialogue": {
			"name": "Vlad",
			"gender": "male",
			"dialogue": "res://characters/dialogue/vladimir/dialogue.gd",
			"current_dialogue": 0
		},
		"stats": {},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"look": {
			"mesh": "res://characters/meshes/patrol/body.tscn"
		}
	},
	"sqlykt": {
		"dialogue": {
			"name": "Sqlykt",
			"gender": "ocelot"
		},
		"stats": {},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"move": {
			"translations": {}
		},
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"skills": {},
		"look": {
			"mesh": "res://characters/meshes/debug/body.tscn"
		}
	},
	"sqlay": {
		"dialogue": {
			"name": "Sqlay",
			"gender": "ocelot"
		},
		"stats": {
			"dead": true,
			"pain": 100.0
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"move": {
			"translations": {}
		},
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"skills": {},
		"look": {
			"mesh": "res://characters/meshes/debug/body.tscn"
		}
	}
}
