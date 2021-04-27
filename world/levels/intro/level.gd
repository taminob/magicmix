extends Spatial


func _on_palace_trigger_body_entered(body):
	if(management.is_player(body)):
		levels.change_level("palace")
