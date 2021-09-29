extends Spatial

var _affected_bodies: Array = []
export(abstract_spell.element_type) var damage_element: int = abstract_spell.element_type.fire
export var initial_damage: float = 10.0
export var damage_per_second: float = 5.0

func _physics_process(delta: float):
	for x in _affected_bodies:
		x.damage(damage_per_second * delta, damage_element)

func _object_enter(body: Node):
	if(body && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(initial_damage, damage_element)

func _object_exit(body: Node):
	if(_affected_bodies.has(body)):
		_affected_bodies.erase(body)
