extends abstract_spell

class_name summon_minion_spell

static func id() -> String:
	return "summon_minion"

func name() -> String:
	return "Summon Minion"

func description() -> String:
	return "Summon a minion that will fight for your cause!"

func category() -> String:
	return "darkness"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "attack",
		"elements": ["darkness", "darkness", "life"]
	}]

func self_pain() -> float:
	return 30.0

func self_focus() -> float:
	return -10.0

func casttime() -> float:
	return 3.0

func cooldown() -> float:
	return 10.0

func start_effect(pawn: KinematicBody):
	var new_minion: KinematicBody = game.mgmt.create_character("minion")
	new_minion.remove_from_group("characters")
	game.levels.current_level.add_child(new_minion)
	# TODO: (BUG) fix spawning in walls
	new_minion.global_transform.origin = pawn.global_transform.origin + pawn.global_transform.basis.xform(Vector3.RIGHT + Vector3.FORWARD)
	new_minion.dialogue.relations = pawn.dialogue.relations
	new_minion.dialogue.set_relation(pawn.name, +2) # todo: use dialogue_state relations
	new_minion.inventory.add_spell(fire_ball_spell.id()) # todo: special minion attacks?

func end_effect(_pawn: KinematicBody):
	pass

func effect(_pawn: KinematicBody, _delta: float):
	pass

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "enemy-512.png")
