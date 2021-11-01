extends Spatial

var fallen_objects = []
var fallen_characters = []

func _on_area_body_entered(body: Node):
	if(body):
		if(body is character):
			fallen_characters.append(body)
			if(game.mgmt.is_player(body)):
				if(game.levels.current_level_death_realm || body.stats.undead):
					var spawn = game.levels.current_level.get_node_or_null("player_spawn")
					if(spawn):
						body.translation = spawn.translation
					else:
						errors.debug_assert(false, "no player_spawn found in " + game.levels.current_level_name)
					#game.levels.change_level(game.levels.current_level_name)
				else:
					body.die() # todo: implement spawn to other levels; implement reset in death realm (already dead)
		else:
			fallen_objects.append(body)
