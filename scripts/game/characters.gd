extends Node

#func get_character_name(character):
#	return character.get("name", "")
#
#func get_gender(character):
#	return character.get("gender", "")
#
#func get_dead(character):
#	return character.get("dead", false)
#
#func get_undead(character):
#	return character.get("undead", false)
#
#func get_pain(character):
#	return character.get("pain", 0.0)
#
#func get_focus(character):
#	return character.get("focus", 0.0)
#
#func get_stamina(character):
#	return character.get("stamina", 0.0)
#
#func get_velocity(character):
#	return character.get("velocity", 0.0)

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
		"inventory": { },
		"skills": {}
	},
	"mary": {
		"dialogue": {
			"name": "Mary",
			"gender": "female"
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
		"inventory": { },
		"skills": {}
	},
	"guenther": {
		"dialogue": {
			"name": "Günther",
			"gender": "male"
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
		"move": {
			"translations": {}
		},
		"inventory": { },
		"skills": {}
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
		"skills": {}
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
		"skills": {}
	}
}
