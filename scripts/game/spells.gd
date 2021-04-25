extends Node

const full = 10000

var spells = {
	"": {
		"combinations": [],
		"name": "Do Nothing",
		"description": "Do nothing!",
		"focus": -5,
		"health": 0,
		"icon": "res://ui/icons/empty_slot_frame-512.png",
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
		"focus": -10,
		"health": 50,
		"icon": "res://ui/icons/circle-512.png",
		"anim": ""
	},
	"blood_sacrifice": {
		"combinations": [{
			"target": "area",
			"type": "defense",
			"elements": ["life", "darkness", "darkness"]
		}],
		"name": "Blood Sacrifice",
		"description": "Sacrifice your own life (or an innocent creature) to revive all allies in a certain radius!",
		"focus": -full,
		"health": -full,
		"icon": "res://ui/icons/self_dark-512.png",
		"anim": ""
	}
}
