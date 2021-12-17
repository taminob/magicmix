extends Spatial

export var spawning_active: bool = false
export var minion_limit: int = 8
var radius: float = 10

func _ready():
	spawn()

func set_active(active: bool):
	spawning_active = active

func spawn(override_limit: bool=false):
	var minion_count = get_child_count()
	if(!override_limit && minion_count >= minion_limit):
		return
	var _next_spawn_position: Vector3 = Vector3.ZERO
	for i in range(minion_limit - minion_count):
		var new_minion: KinematicBody = game.mgmt.create_character("minion")
		new_minion.remove_from_group("characters")
		game.levels.current_level.call_deferred("add_child", new_minion)
		call_deferred("_set_minion_properties", new_minion, i)

func _set_minion_properties(minion: KinematicBody, minion_id: int):
	# TODO: fix targeting
	minion.dialogue.relations = {game.mgmt.player_id: dialogue_state.relation.enemy}
	#minion.inventory.add_spell(fire_ball_spell.id()) # todo: special minion attacks?
	minion.inventory.spells = skill_data.spells.keys()

	minion.translation = radius * Vector3(sin(float(minion_id) / minion_limit * TAU), 0, cos(float(minion_id) / minion_limit * TAU))
	minion.face_target(self)
