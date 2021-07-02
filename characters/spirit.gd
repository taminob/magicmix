extends KinematicBody

var character: character

func get_interaction() -> String:
	return character.get_interaction()

func interact(interactor: character):
	character.interact(interactor)
