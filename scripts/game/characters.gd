extends Node

const FULL_PAIN: float = 10000.0

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
		},
		"ai": {}
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
			"slots": ["fire_ring", "heal", "", "", ""]
		},
		"skills": {},
		"look": {
			"mesh": "res://characters/meshes/default/body.tscn"
		},
		"ai": {}
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
			"pain": FULL_PAIN
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"skills": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["blood_storm", "fire_ring", "", "", ""]
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
			"current_dialogue": 0,
			"job": "guard"
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
		},
		"ai": {}
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
		},
		"ai": {}
	},
	"sqlay": {
		"dialogue": {
			"name": "Sqlay",
			"gender": "ocelot"
		},
		"stats": {
			"dead": true,
			"pain": FULL_PAIN
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
		},
		"ai": {}
	}
}
