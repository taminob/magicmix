extends Node3D

@onready var minion_spawner: Node3D = $"minion_spawner"

func _ready():
	minion_spawner.minion_limit = game.levels.current_level_data.data["minion_limit"]
	minion_spawner.spawn()
