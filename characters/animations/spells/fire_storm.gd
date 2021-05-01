extends Spatial

var caster = null
var affected_bodies = []
const spell_name = "fire_storm"

func _ready():
	caster = get_parent()

func _physics_process(delta):
	for x in affected_bodies:
		x.damage(spells.get_pain(spells.get_spell(spell_name), "target", true) * delta)

func _on_area_of_effect_body_entered(body):
	if(body.has_method("damage") && body != caster):
		affected_bodies.append(body)


func _on_area_of_effect_body_exited(body):
	if(affected_bodies.has(body)):
		affected_bodies.erase(body)
