extends Node

var achievement_data: Dictionary = {
	"all_dialogues": {
		"name": "Way too much talk",
		"description": "See every dialogue text at least once.",
		"condition": funcref(self, "_all_dialogues_unlock")
	},
	"high_speed": {
		"name": "Light is my name",
		"description": "Be fast.",
		"condition": funcref(self, "_high_speed_unlock")
	},
	"all_dead": {
		"name": "I bring death",
		"description": "Kill them. All of them. Then yourself.",
		"condition": funcref(self, "_all_dead_unlock")
	}
}

var achievement_progress: Dictionary = {}

func _process(_delta: float):
	for achievement in achievement_data.keys():
		if(achievement_progress.get(achievement, false)):
			continue
		var unlock_func: FuncRef = achievement_data[achievement]["condition"]
		if(unlock_func):
			achievement_progress[achievement] = unlock_func.call_func()

func _all_dialogues_unlock() -> bool:
	return true

func _all_dead_unlock() -> bool:
	for x in game.mgmt.char_data.values():
		if(!x.get("stats", {}).get("dead", false)):
			return false
	return true

func _high_speed_unlock() -> bool:
	return game.mgmt.player.move.velocity.length_squared() > 1000.0
