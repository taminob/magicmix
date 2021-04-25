extends CSGMesh


func _on_trigger_body_entered(body):
	if(body.name != inventory.player_character):
		return
	inventory.player_character = "hans"
	var world = $".."
	world.remove_child(world.get_node("level"))
	var level = load("res://world/levels/intro/intro_level.tscn").instance()
	level.name = "level"
	world.add_child(level)
