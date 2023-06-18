extends Node3D



func _on_guard_house_trigger_body_entered(body):
	if(game.mgmt.is_player(body)):
		game.levels.change_level("debug_death1")


func _on_palace_trigger_body_entered(_body):
	pass # todo? implement
