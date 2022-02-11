extends Spatial

export var spawn_on_ready: bool = false
export var minion_limit: int = 0
export var radius: float = 10
var minion_ids: Array = []

func _ready():
	if(spawn_on_ready):
		spawn()

func clear():
	for x in minion_ids:
		x.queue_free()

func spawn(override_limit: bool=false):
	var minion_count = 0
	if(!override_limit):
		for x in game.levels.current_level.get_children():
			if(x.name in minion_ids):
				minion_count += 1
			else:
				minion_ids.erase(x.name)
		if(minion_count >= minion_limit):
			return

	var _next_spawn_position: Vector3 = Vector3.ZERO
	for i in range(minion_limit - minion_count):
		var new_minion: KinematicBody = game.mgmt.create_character("minion")
		new_minion.remove_from_group("characters")
		game.levels.current_level.call_deferred("add_child", new_minion)
		call_deferred("_set_minion_properties", new_minion, i)

func _set_minion_properties(minion: KinematicBody, minion_id: int):
	# TODO: fix targeting
	minion.dialogue.relations = {game.mgmt.player_id: -2} # todo: dialogue_state.relation.enemy
	#minion.inventory.add_spell(fire_ball_spell.id()) # todo: special minion attacks?
	minion.inventory.spells = skill_data.spells.keys()

	var pos: Vector3 = Vector3(sin(float(minion_id) / minion_limit * TAU), 0, cos(float(minion_id) / minion_limit * TAU))
	minion.global_transform.origin = global_transform.origin + radius * pos
	minion.face_target(self)
