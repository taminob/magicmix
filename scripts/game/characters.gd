extends Node

var characters = {
	"hans": {
		"name": "Hans",
		"gender": "male",
		"dead": false,
		"undead": false,
		"pain": 0.0,
		"focus": 0.0,
		"velocity": Vector3.ZERO,
		"translations": {},
		"items": [],
		"spells": []
	},
	"mary": {
		"name": "Mary",
		"gender": "female",
		"dead": false,
		"undead": false,
		"pain": 0.0,
		"focus": 0.0,
		"velocity": Vector3.ZERO,
		"translations": {},
		"items": [],
		"spells": []
	},
	"guenther": {
		"name": "Günther",
		"gender": "male",
		"dead": true,
		"undead": true,
		"pain": 0.0,
		"focus": 0.0,
		"velocity": Vector3.ZERO,
		"translations": {},
		"items": [],
		"spells": []
	},
	"sqlykt": {
		"name": "Sqlykt",
		"gender": "ocelot",
		"dead": false,
		"undead": false,
		"pain": 0.0,
		"focus": 0.0,
		"velocity": Vector3.ZERO,
		"translations": {},
		"items": [],
		"spells": ["blood_sacrifice"]
	},
	"sqlay": {
		"name": "Sqlay",
		"gender": "ocelot",
		"dead": true,
		"undead": false,
		"pain": 0.0,
		"focus": 0.0,
		"velocity": Vector3.ZERO,
		"translations": {},
		"items": [],
		"spells": ["blood_sacrifice"]
	}
}
