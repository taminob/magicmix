extends CSGMesh


func _on_trigger_body_entered(body):
	if(body == null || body != management.player):
		return
	management.unmake_player()
	characters.characters[management.player_name]["dead"] = true
	management.player_name = "mary" if(management.player_name == "hans") else "hans"
	management.change_level(load("res://world/levels/intro/intro.tscn").instance())
	#inventory.change_level(load("res://world/death_realm/death_realm.tscn").instance())
#	body.pain = 0.0
#	body.dead = false
#	body.in_death_realm = false
