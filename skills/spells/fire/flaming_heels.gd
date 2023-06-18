extends abstract_spell

class_name flaming_heels_spell

static func id() -> String:
	return "flaming_heels"

func name() -> String:
	return "Flaming Heels"

func description() -> String:
	return "Run like fire itself!"

func category() -> String:
	return "fire"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "defense",
		"elements": ["fire", "fire", "life"]
	}]

func self_focus() -> float:
	return -10.0

func self_focus_per_second() -> float:
	return -5.0

const PAIN_PER_SHARD: float = -25.0
const SPEED_FACTOR_INCREASE: float = 1.5
func start_effect(pawn: CharacterBody3D):
	pawn.move.velocity = -pawn.global_transform.basis.z * 25
	pawn.move.base_speed_factor += SPEED_FACTOR_INCREASE

func end_effect(pawn: CharacterBody3D):
	pawn.move.base_speed_factor = max(pawn.move.base_speed_factor - SPEED_FACTOR_INCREASE, move_state.MIN_SPEED_FACTOR)

func casttime() -> float:
	return 0.25

func cooldown() -> float:
	return 4.0

func duration() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/magma-512.png")
