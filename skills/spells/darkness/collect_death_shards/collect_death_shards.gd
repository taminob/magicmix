extends abstract_spell

class_name collect_death_shards_spell

static func id() -> String:
	return "collect_death_shards"

func name() -> String:
	return "Collect Death Shards"

func description() -> String:
	return "Draw from the remains of the nearby fallen!"

func category() -> String:
	return "darkness"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "defense",
		"elements": ["darkness", "darkness", "darkness"]
	}]

func self_pain() -> float:
	return 50.0

func self_focus() -> float:
	return 5.0

func _is_death_shard(body: Node) -> bool:
	return body.get_parent().name.find("death_shard") != -1

const PAIN_PER_SHARD: float = -25.0
func start_effect(pawn: KinematicBody):
	var shards: Array = pawn.interaction.get_near_bodies(self.range(), funcref(self, "_is_death_shard"))
	pawn.damage(shards.size() * PAIN_PER_SHARD, element_type.raw)
	for shard in shards:
		# todo: animate shard consumption
		shard.get_parent().queue_free()

func casttime() -> float:
	return 0.5

func cooldown() -> float:
	return 2.5

func duration() -> float:
	return 0.0

func range() -> float:
	return 15.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "blood_scratch-512.png")

func scene() -> Node:
	return null#load("scene/blood_dash.tscn").instance()
