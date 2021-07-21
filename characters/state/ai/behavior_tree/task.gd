extends Node

class_name task

# todo: implement utiliy ai based system with score system for each action with a score add/sub based on each input
# or: goap (goal-oriented action planning), so setting a goal and having actions with a set of dynamic (funcions) pre- and post-conditions

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
	errors.debug_assert(parent != null, "behavior tree has to be child of a character")
	var expected_name = get_script().resource_path.get_file().split('.')[0]
	errors.debug_assert(expected_name == name.substr(0, expected_name.length()), "behavior tree task has wrong name (does not match task class)")
	pawn = parent
	init()

func init_children():
	for x in get_children():
		if(x as task):
			x.init()

func cancel():
	for x in get_children():
		if(x as task):
			x.cancel()
	_status = task_status.CANCEL

# implement init if task changes state in _run
func init():
	_status = task_status.NEW

# implement task here
func _run(_delta: float) -> int:
	if(_status == task_status.CANCEL):
		return task_status.CANCEL
	return task_status.SUCCESS

var _status: int = task_status.NEW
func run(delta: float) -> int:
	if(_status == task_status.RUNNING):
		_status = _run(delta)
	return _status

func start(controlled_character: character):
	reset()
	pawn = controlled_character
	_status = task_status.RUNNING

func reset():
	cancel()
	init()
