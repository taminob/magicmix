extends abstract_skill

class_name shield_stance_skill

static func id() -> String:
	return "shield_stance"

func name() -> String:
	return "Defensive Stance"

func description() -> String:
	return "Remain static to strengthen your defences!"

func category() -> String:
	return "ice"

func requirements() -> Array:
	return [base_ice_skill.id()]

func mutually_exclusive() -> Array:
	return ["shield_sprint"]

const EFFECT_FACTOR: float = 0.5
func effect(pawn: KinematicBody, delta: float):
	# TODO: increase gain over time when standing still for longer
	if(pawn.move.velocity.is_equal_approx(Vector3.ZERO)):
		pawn.stats.add_shield(pawn.stats.max_shield() * EFFECT_FACTOR * delta)

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/letter_d-512.png")
