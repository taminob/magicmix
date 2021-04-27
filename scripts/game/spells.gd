extends Node

const full = 10000

var spells = {
	"": {
		"combinations": [],
		"name": "Do Nothing",
		"description": "Do nothing!",
		"category": "",
		"focus": -5,
		"health": 0,
		"icon": load("res://ui/icons/empty_slot_frame-512.png"),
		"anim": ""
	},
	"heal": {
		"combinations": [{
			"target": "self",
			"type": "defense",
			"elements": ["life"]
		}],
		"name": "Heal",
		"description": "Heal yourself for a bit!",
		"category": "heal",
		"focus": -10,
		"health": 50,
		"icon": load("res://ui/icons/circle-512.png"),
		"anim": ""
	},
	"blood_sacrifice": {
		"combinations": [{
			"target": "self",
			"type": "defense",
			"elements": ["life", "life", "darkness"]
		}],
		"name": "Blood Sacrifice",
		"description": "Sacrifice your own life (or an innocent creature) to revive the nearest ally!",
		"category": "blood",
		"focus": -full,
		"health": -full,
		"icon": load("res://ui/icons/self_dark-512.png"),
		"anim": ""
	}
}
