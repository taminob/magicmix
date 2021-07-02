extends Node

var interaction_name: String
var _interact_object: Node = null

func _ready():
	_interact_object = get_parent()
	while _interact_object && !_interact_object.has_method("interact"):
		_interact_object = _interact_object.get_parent()
	assert(_interact_object && _interact_object.has_method("interact"))
	_update_interaction_name()

func interact(interactor: character):
	_interact_object.interact(interactor)
	_update_interaction_name()

func _update_interaction_name():
	interaction_name = _interact_object.interaction_name
