extends Popup

var commands = {
	"load": {
		"handler": funcref(game.levels, "change_level"),
		"possible": game.levels.levels.keys()
	},
	"exit": {
		"handler": funcref(self, "unpause")
	},
	"reload": {
		
	},
	"save": {
		
	},
	"inspect": {
		"handler": funcref(self, "inspect_handler"),
		"possible": game.char_data.keys()
	}
}

func inspect_handler(character_id: String):
	settings.set_setting("dev", "debug_target", character_id)

onready var output = $"output_background/output"
onready var input = $"command_input"

var hidden: bool = true

func prepare_leave():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	saves.save()
	hidden = true
	get_tree().paused = false # todo: test if unpausing here is a good idea

func unpause():
	input.clear()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hidden = true
	get_tree().paused = false
	hide()

func pause():
	input.clear()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hidden = false
	get_tree().paused = true
	popup()

func _enter_tree():
	if(!hidden):
		get_tree().paused = true
		call_deferred("popup")

func _input(event: InputEvent):
	if(!settings.get_setting("dev", "console")):
		return
	if(event.is_action_pressed("console")):
		if(hidden):
			pause()
		else:
			unpause()

func _on_command_input_text_changed(_new_text: String):
	# todo: autocompletion and suggestions
	pass

func _on_command_input_text_entered(new_text: String):
	# todo: improve parsing and command handling; more robust and allow multiple arguments and complexer commands
	var input_strings: PoolStringArray = new_text.to_lower().split(' ', false)
	if(input_strings.empty()):
		output.set_text("No command!")
		return
	var command = commands.get(input_strings[0])
	if(!command):
		output.set_text("Command not found!")
		return
	var handler = command.get("handler")
	if(!handler):
		output.set_text("Internal error: no command handler found!")
		return
	var possible_args = command.get("possible")
	if(possible_args):
		if(input_strings.size() > 1 && possible_args.has(input_strings[1])):
			handler.call_func(input_strings[1])
		else:
			output.set_text("Invalid argument!\nPossible arguments: " + str(possible_args))
			return
	else:
		handler.call_func()
	input.clear()
