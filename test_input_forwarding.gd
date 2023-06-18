extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	$"world_container/viewport".push_input(event)
	$"pause_menu".push_input(event)
	$"console".push_input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
