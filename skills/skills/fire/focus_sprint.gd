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

func mutually_exlusive() -> Array:
	return ["focus_stance"]

func on_allocated(pawn: CharacterBody3D):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(flaming_heels_spell.id())

func on_retracted(pawn: CharacterBody3D):
	pawn.inventory.remove_spell(flaming_heels_spell.id())

const EFFECT_FACTOR: float = 0.1
func effect(pawn: CharacterBody3D, _delta: float):
	# TODO: disable normal focus_per_second regeneration
	pawn.damage(pawn.move.velocity.length_squared() * EFFECT_FACTOR, abstract_spell.element_type.focus)

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/letter_f-512.png")
