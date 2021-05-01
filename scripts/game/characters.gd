extends Node

func get_character(id):
	return characters.get(id, "")

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

var characters = {
	"hans": {
		"name": "Hans",
		"gender": "male",
		"pain": 0.0,
		"focus": 0.0,
		"stamina": 0.0,
		"experience": {
			"intelligence": 1,
			"strength": 1,
			"sturdiness": 1,
			"concentration": 1,
			"endurance": 1
		},
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
		"pain": 100.0,
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
