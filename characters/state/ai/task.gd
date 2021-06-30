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
	while !parent is character && parent:
		parent = parent.get_parent()
	assert(parent, "behavior tree has to be child of a character")
	pawn = parent
	init()

func init_children():
	for x in get_children():
		x.init()

func cancel():
#	for x in get_children():
#		x.cancel()
	_root_status = task_status.CANCEL

# implement init if task changes state in _run
func init():
	pass

# implement task here
func _run(_delta: float) -> int:
	return task_status.SUCCESS

var _root_status: int = task_status.NEW
func run(delta: float) -> int:
	if(_root_status == task_status.RUNNING):
		_root_status = _run(delta)
	return _root_status

func start(controlled_character: character):
	reset()
	pawn = controlled_character
	_root_status = task_status.RUNNING

func reset():
	cancel()
	init()
