extends abstract_skill

class_name focus_sprint_skill

func name() -> String:
	return "Focused Sprint"

func description() -> String:
	return "Use kinematic energy to regain focus!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return []

func effect(pawn: character, delta: float):
	pawn.stats.damage(pawn.move.velocity.length_squared(), true)

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blue_star-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
