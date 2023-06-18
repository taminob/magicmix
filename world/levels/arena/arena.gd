extends Node3D

@onready var enemies_spawn_point: Node3D = $"enemies_spawn_point"
const MAX_PER_ROW: int = 5

func _ready():
	var enemies: Array = game.levels.current_level_data.data.get("enemies", [])
	if(!enemies.is_empty()):
		spawn_enemies(enemies)

func spawn_enemies(enemies: Array):
	var amount: int = enemies.size()
	var row: int = -int(ceil(amount / MAX_PER_ROW)) #warning-ignore:integer_division
	var column: float = -0.5 * (wrapi(amount % MAX_PER_ROW, 1, 5) - 1)
	var column_end: float = -column
	for enemy_id in enemies:
		var enemy: CharacterBody3D = game.mgmt.create_character(enemy_id)
		enemy.position.x = column
		enemy.position.z = row
		enemies_spawn_point.add_child(enemy)
		if(column == column_end):
			row += 1
			column = -0.5 * (wrapi(amount % MAX_PER_ROW, 1, 5) - 1)
			column_end = -column
		else:
			column += 1
