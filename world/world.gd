extends Node3D

var fallen_up_objects: Array = []
var fallen_down_objects: Array = []
var fallen_up_characters: Array = []
var fallen_down_characters: Array = []

func _on_fall_area_entered(body: Node, up: bool):
	if(body):
		if(body is character):
			if(up):
				fallen_up_characters.append(body)
			else:
				fallen_down_characters.append(body)
			if(game.mgmt.is_player(body)):
				_player_fallen(up)
			else:
				body.die() # todo: implement spawn to other levels; implement reset in death realm (already dead)
		else:
			if(up):
				fallen_up_objects.append(body)
			else:
				fallen_down_objects.append(body)
			body.queue_free() # todo: can cause double free issue with e.g. platform_spell

func _player_fallen(up: bool):
	var body: CharacterBody3D = game.mgmt.player
	if(up):
		if(game.levels.current_level_data.is_in_death_realm()):
			game.levels.change_level("death_arena")
		else:
			body.die()
	else:
		if(game.levels.current_level_data.is_in_death_realm() || body.stats.undead):
			_reset_body(body)
		else:
			body.die()

func _reset_body(body: Node):
	var spawn = game.levels.get_spawn(body.name)
	if(spawn):
		body.position = spawn.position
	else:
		errors.debug_output("no spawn found in " + game.levels.current_level_data.id() + " for " + body.name)
