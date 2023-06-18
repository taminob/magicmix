extends Node

var _interact_object: Node = null

func _ready():
	_interact_object = get_parent()
	while _interact_object && !_interact_object.has_method("interact"):
		_interact_object = _interact_object.get_parent()
	errors.assert_always(_interact_object && _interact_object.has_method("interact"), "parents of child_interact not interactable")

func get_interaction() -> String:
	return _interact_object.get_interaction()

func interact(interactor: character):
	_interact_object.interact(interactor)
