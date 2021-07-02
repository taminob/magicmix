extends Spatial

var fallen_objects = []
var fallen_characters = []

func _on_area_body_entered(body: Node):
	if(body):
		if(body is character):
			fallen_characters.append(body)
			if(game.mgmt.is_player(body)):
				body.die() # todo: implement spawn to other levels
		else:
			fallen_objects.append(body)
