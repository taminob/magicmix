extends abstract_skill

class_name shield_sprint_skill

static func id() -> String:
	return "shield_sprint"

func name() -> String:
	return "Defensive Sprint"

func description() -> String:
	return "Use kinematic energy to fuel your defenses!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return [base_fire_skill.id()]

func mutually_exclusive() -> Array:
	return ["shield_stance"]

const EFFECT_FACTOR: float = 0.5
func effect(pawn: CharacterBody3D, _delta: float):
	pawn.stats.add_shield(pawn.move.velocity.length_squared() * EFFECT_FACTOR)

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/letter_d-512.png")
