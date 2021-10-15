extends abstract_skill

class_name focus_sprint_skill

static func id() -> String:
	return "focus_sprint"

func name() -> String:
	return "Focused Sprint"

func description() -> String:
	return "Use kinematic energy to regain focus at the cost of your natural regeneration!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return [base_fire_skill.id()]

const EFFECT_FACTOR: float = 0.1
func effect(pawn: character, _delta: float):
	# TODO: disable normal focus_per_second regeneration
	pawn.stats.damage(pawn.move.velocity.length_squared() * EFFECT_FACTOR, abstract_spell.element_type.focus)

func duration() -> float:
	return 10.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/letter_f-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
