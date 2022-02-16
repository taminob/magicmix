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
	return 25.0

func self_focus() -> float:
	return 5.0

func _is_death_shard(body: Node) -> bool:
	return body.get("is_uncollected_death_shard")

const PAIN_PER_SHARD: float = -25.0
func start_effect(pawn: KinematicBody):
	var shards: Array = pawn.interaction.get_near_bodies(self.range(), funcref(self, "_is_death_shard"))
	if(shards.empty()):
		return
	pawn.damage(shards.size() * PAIN_PER_SHARD, element_type.raw)
	var shard_collection: Spatial = pawn.get_node_or_null("shards")
	if(!shard_collection):
		shard_collection = Spatial.new()
		shard_collection.name = "shards"
		pawn.add_child(shard_collection)
	else:
		shards.append_array(shard_collection.get_children())

	var distance: float = 0.75
	var pos: float = -distance / 2 * (shards.size() - 1)
	for shard in shards:
		# todo: animate shard consumption
		shard.get_parent().remove_child(shard)
		shard.translation = Vector3(pos, 1, 0.6)
		pos += distance
		shard.pick_up(pawn)
		shard_collection.call_deferred("add_child", shard)

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
