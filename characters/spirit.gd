extends KinematicBody

var pawn: character

func get_interaction() -> String:
	return pawn.get_interaction()

func interact(interactor: character):
	pawn.interact(interactor)
