extends abstract_skill

class_name become_undead_skill

static func id() -> String:
	return "become_undead"

func name() -> String:
	return "Become Undead"

func description() -> String:
	return "Death will be always with you. Die and enjoy all the advantages. But be aware of the limitations!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id()]

func on_allocated(pawn: character):
	pawn.stats.undead = true

func on_retracted(pawn: character):
	pawn.stats.undead = false

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "self_dark-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
