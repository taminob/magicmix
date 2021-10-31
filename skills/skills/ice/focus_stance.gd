extends abstract_skill

class_name focus_stance_skill

static func id() -> String:
	return "focus_stance"

func name() -> String:
	return "Focused Stance"

func description() -> String:
	return "Remain static to regain focus at the cost of your natural regeneration!"

func category() -> String:
	return "ice"

func requirements() -> Array:
	return [base_ice_skill.id()]

func mutually_exclusive() -> Array:
	return ["focus_sprint"]

const EFFECT_FACTOR: float = 0.1
func effect(pawn: KinematicBody, delta: float):
	# TODO: better way to disable normal focus_per_second regeneration
	# TODO: increase focus gain over time when standing still for longer
	if(pawn.move.velocity.is_equal_approx(Vector3.ZERO)):
		pawn.damage(pawn.stats.max_focus() * EFFECT_FACTOR * delta, abstract_spell.element_type.focus)
	else:
		pawn.damage(-pawn.stats.focus_per_second(), abstract_spell.element_type.focus)

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/letter_f-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
