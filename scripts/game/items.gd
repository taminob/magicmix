extends Node

const full = 10000
const item_icons_path = "res://ui/icons/items/"

# warning-ignore:unused_class_variable
var items = {
	"": {
		"name": "",
		"description": "",
		"category": "",
		"self": {
			"pain": 0,
			"pain_per_second": 0,
			"focus": 0,
			"focus_per_second": 0
		},
		"target": {
			"pain": 0,
			"pain_per_second": 0,
			"focus": 0,
			"focus_per_second": 0
		},
		"duration": 0,
		"icon": load(item_icons_path + "../empty-512.png"),
		"anim": ""
	},
	"deadly_poison": {
		"name": "Deadly Poison",
		"description": "This will kill you, do not drink!",
		"category": "consumable",
		"self": {
			"pain": full,
			"pain_per_second": full,
			"focus": -full,
			"focus_per_second": -full
		},
		"duration": full,
		"icon": load(item_icons_path + "poison_flask-512.png")
	},
	"dark_token": {
		"name": "Token of Darkness",
		"description": "Pledge your soul to the dark and strengthen your powers of the black art!",
		"category": "token",
		"icon": load(item_icons_path + "dark_token-512.png")
	},
	"fire_token": {
		"name": "Token of Fire",
		"description": "Pledge your soul to the fire and increase your control over all heat!",
		"category": "token",
		"icon": load(item_icons_path + "fire_token-512.png")
	},
	"dark_potion": {
		"name": "Dark Potion",
		"description": "Consume dark spirits and let their power guide you!",
		"category": "consumable",
		"self": {
			"pain": 0.5,
		},
		"icon": load(item_icons_path + "dark_potion-512.png")
	}
}
