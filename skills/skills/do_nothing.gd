extends abstract_skill

class_name do_nothing_skill

func name() -> String:
	return "Do Nothing"

func description() -> String:
	return "Nothing special!"

# TODO: remove (debug)
func start_effect(pawn: character):
	pawn.stats.shield_element = pawn.skills.current_element
	pawn.stats.shield = pawn.stats.max_shield()
