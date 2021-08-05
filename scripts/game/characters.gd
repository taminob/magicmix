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
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(1, 1, 0)
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
			"spells": ["fire_ball", "fire_ring", "fire_storm", "blood_sacrifice", "heal", "blood_storm", "blood_heal"],
			"slots": ["heal", "fire_ring", "fire_ball", "blood_storm", "blood_sacrifice"]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.45, 0, 0)
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
			"spells": ["fire_ball", "fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["fire_ball", "fire_ring", "", "", "heal"]
		},
		"stats": {
			"focus": 100,
			"pain": 30
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0, 0.8, 0)
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
			"spells": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.5, 0, 0.5)
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
			"spells": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["blood_storm", "fire_ring", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0, 0, 1)
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
			"spells": ["fire_ring", "blood_sacrifice", "heal", "blood_storm"],
			"slots": ["fire_ring", "heal", "", "", ""]
		},
		"look": {
			"mesh_path": "res://characters/meshes/shade/body.tscn",
			"color": Color(0.5, 0.5, 1)
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
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.3, 0.3, 0.3)
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
			"mesh_path": "res://characters/meshes/debug/body.tscn",
			"color": Color(0.5, 0.5, 0.5)
		},
	}
}
