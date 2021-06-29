extends Node

class_name task

enum task_status {
	SUCCESS,
	FAIL,
	RUNNING,
	CANCEL,
	NEW
}

var pawn: character

func _ready():
	var parent: Node = get_parent()
	var is_root
	while !parent is character && parent:
		parent = parent.get_parent()
	pawn = parent
	init()

func init():
	pass

func init_children():
	for x in get_children():
		x.init()

func cancel() -> int:
	for x in get_children():
		x.cancel()
	return task_status.CANCEL

# implement task
func _run(delta: float) -> int:
	return task_status.SUCCESS

var _root_status: int = task_status.NEW
func run(delta: float) -> int:
	if(_root_status == task_status.RUNNING):
		_root_status = _run(delta)
	return _root_status

func start(controlled_character: character):
	pawn = controlled_character
	_root_status = task_status.RUNNING

func reset():
	cancel()
	init()
