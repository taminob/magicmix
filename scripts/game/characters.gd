extends Node

const FULL_PAIN: float = 10000.0

# warning-ignore:unused_class_variable
var character_data = {
	"gerhard": {
		"dialogue": {
			"name": "Gerhard",
			"gender": "male",
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
			"mesh_path": "res://characters/meshes/patrol/body.tscn"
		},
	},
	"hans": {
		"dialogue": {
			"name": "Hans",
			"gender": "male",
			"job": "thief"
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"stats": {
			"focus": 70
		},
		"inventory": {
			"skills": ["fire_ball", "fire_ring", "fire_storm", "blood_sacrifice", "heal", "blood_storm", "blood_heal"],
			"slots": ["heal", "fire_ring", "fire_ball", "blood_storm", "blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn"
		},
	},
	"mary": {
		"dialogue": {
			"name": "Mary",
			"gender": "female",
			"relations": {
				"hans": 1,
				"vladimir": 2
			}
		},
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
		"inventory": {
			"skills": ["fire_ball", "fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["fire_ball", "fire_ring", "", "", "heal"]
		},
		"stats": {
			"focus": 100,
			"pain": 30
		},
		"look": {
			"mesh_path": "res://characters/meshes/woman/body.tscn"
		},
	},
	"guenther": {
		"dialogue": {
			"name": "Günther",
			"gender": "male",
			"relations": {
				"hans": 2,
				"vladimir": -1
			}
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
			"mesh_path": "res://characters/meshes/patrol/body.tscn"
		}
	},
	"gress": {
		"dialogue": {
			"name": "Gress",
			"gender": "male",
			"relations": {
				"hans": 2,
				"vladimir": -1
			}
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
		"inventory": {
			"skills": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/patrol/body.tscn"
		}
	},
	"vladimir": {
		"dialogue": {
			"name": "Vlad",
			"gender": "male",
			"relations": {
				"hans": -2,
				"mary": 2
			},
			"job": "guard"
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
			"slots": ["fire_ring", "heal", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/patrol/body.tscn"
		},
	},
	"sqlykt": {
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
			"mesh_path": "res://characters/meshes/debug/body.tscn"
		},
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
		"inventory": {
			"spells": ["blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/debug/body.tscn"
		},
	}
}
