extends Node3D


func _on_palace_trigger_body_entered(body):
	if(game.mgmt.is_player(body)):
		game.levels.change_level("debug2")
	elif(body is character):
		pass # todo: let other characters enter palace as well
