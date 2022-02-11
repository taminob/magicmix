extends Spatial

onready var minion_spawner: Spatial = $"minion_spawner"

func _ready():
	minion_spawner.minion_limit = game.levels.current_level_data.data.get("minion_limit", 3)
