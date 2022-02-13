extends abstract_spell

class_name blood_dash_spell

static func id() -> String:
	return "blood_dash"

func name() -> String:
	return "Blood Dash"

func description() -> String:
	return "Endure the pain it costs to bend space to your will!"

func category() -> String:
	return "blood"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "attack",
		"elements": ["life", "darkness", "fire"]
	}]

func self_pain() -> float:
	return 0.0#20.0

func self_focus() -> float:
	return 5.0

func start_effect(pawn: KinematicBody):
	pawn.move.velocity = -pawn.global_transform.basis.z * 200

func end_effect(pawn: KinematicBody):
	pass

func effect(_pawn: KinematicBody, _delta: float):
	pass

func casttime() -> float:
	return 0.0

func cooldown() -> float:
	return 0.5

func duration() -> float:
	return 0.3

func range() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "blood_scratch-512.png")

func scene() -> Node:
	return null#load("scene/blood_dash.tscn").instance()
