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
	return [taint_life_skill.id()]

func on_allocated(pawn: CharacterBody3D):
	pawn.stats.undead = true
	#pawn.look.call_deferred("update_look")

func on_retracted(pawn: CharacterBody3D):
	pawn.stats.undead = false
	pawn.look.update_look()

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "self_dark-512.png")
