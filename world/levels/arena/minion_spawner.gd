extends Spatial

export var spawning_active: bool = false
export var minions_limit: int = 1
var wave_size: int = 20
var radius: float = 10

func _ready():
	spawn()

func set_active(active: bool):
	spawning_active = active

func spawn(override_limit: bool=false):
	var minion_count = get_child_count()
	if(!override_limit && minion_count >= minions_limit):
		return
	var _next_spawn_position: Vector3 = Vector3.ZERO
	for i in range(wave_size):
		var new_char: character = game.mgmt.create_character("minion")
		add_child(new_char)
		new_char.translation = radius * Vector3(sin(float(i) / wave_size * TAU), 0, cos(float(i) / wave_size * TAU))
		new_char.face_target(self)
