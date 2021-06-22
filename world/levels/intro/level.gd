extends Spatial


func _on_palace_trigger_body_entered(body):
	if(game.mgmt.is_player(body)):
		game.levels.change_level("palace")
