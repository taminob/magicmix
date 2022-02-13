extends abstract_spell

class_name ice_ride_spell

static func id() -> String:
	return "ice_ride"

func name() -> String:
	return "Ride Ice"

func description() -> String:
	return "Ride on top of a wave of ice!"

func category() -> String:
	return "ice"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "attack",
		"elements": ["ice", "ice", "ice"]
	}]

func self_focus() -> float:
	return -10.0

func self_focus_per_second() -> float:
	return -5.0

func target_element() -> int:
	return element_type.ice

func target_pain() -> float:
	return 10.0

func target_focus() -> float:
	return -10.0

const EFFECT_FACTOR: float = 20.0
func effect(pawn: KinematicBody, _delta: float):
	pawn.move.velocity = pawn.global_transform.basis.xform(Vector3.FORWARD) * EFFECT_FACTOR

func duration() -> float:
	return 10.0

func range() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/star_fall-512.png")

func scene() -> Node:
	return preload("scene/ice_ride.tscn").instance()
