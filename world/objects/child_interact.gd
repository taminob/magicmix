extends Node

var _interact_object: Node = null

func _ready():
	_interact_object = get_parent()
	while _interact_object && !_interact_object.has_method("interact"):
		_interact_object = _interact_object.get_parent()
	assert(_interact_object && _interact_object.has_method("interact"))

func get_interaction() -> String:
	return _interact_object.get_interaction()

func interact(interactor: character):
	_interact_object.interact(interactor)
