extends Node

class_name task

enum task_status {
	NEW,
	RUNNING,
	FAILED,
	SUCCEEDED,
	CANCELLED,
}

var parent_task: task = null
var root_task: task = null
var status: int = task_status.NEW

func running():
	status = task_status.RUNNING
	if parent_task != null:
		parent_task.child_running()

func success():
	status = task_status.SUCCEEDED
	if parent_task != null:
		parent_task.child_success()

func fail():
	status = task_status.FAILED
	if parent_task != null:
		parent_task.child_fail()

func cancel():
	if status == task_status.RUNNING:
		status = task_status.CANCELLED
		# Cancel child tasks
		for child in get_children():
			child.cancel()

# Abstract methods
func run():
	# Process the task and call running(), success(), or fail()
	pass

func child_success():
	pass

func child_fail():
	pass

func child_running():
	pass

# Non-final non-abstact methods
func start():
	status = task_status.NEW
	for child in get_children():
		child.control = self
		child.tree = self.tree
		child.start()

func reset():
	cancel()
	status = task_status.NEW
