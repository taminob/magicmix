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
	return [focus_sprint_skill.id()]

const EFFECT_FACTOR: float = 0.5
func effect(pawn: character, _delta: float):
	pawn.stats.add_shield(pawn.move.velocity.length_squared() * EFFECT_FACTOR)

func duration() -> float:
	return 10.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../todo-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
