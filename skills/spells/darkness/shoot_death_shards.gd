extends abstract_spell

class_name shoot_death_shards_spell

static func id() -> String:
	return "shoot_death_shards_spell"

func name() -> String:
	return "Shoot Death Shard"

func description() -> String:
	return "Fire a collected death shard at your enemy!"

func category() -> String:
	return "darkness"

func combinations() -> Array:
	return [{
		"target": "target",
		"type": "attack",
		"elements": ["darkness", "darkness", "life"]
	}]

func self_pain() -> float:
	return 5.0

func self_focus() -> float:
	return 20.0

func target_pain() -> float:
	return 90.0

func _is_death_shard(body: Node) -> bool:
	return body.get_parent().get("is_uncollected_death_shard")

func start_effect(pawn: KinematicBody):
	var shard_collection: Spatial = pawn.get_node_or_null("shards")
	if(!shard_collection || shard_collection.get_child_count() < 1):
		return
	var projectile: Spatial = shard_collection.get_child(0)
	shard_collection.remove_child(projectile)
	game.levels.current_level.add_child(projectile)
	projectile.shoot()

	# reorder the remaining shards
	var shards: Array = shard_collection.get_children()
	var distance: float = 0.75
	var pos: float = -distance / 2 * (shards.size() - 1)
	for shard in shards:
		shard.translation = Vector3(pos, 1, 0.6)
		pos += distance

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
