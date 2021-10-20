extends Popup

var commands = {
	"help": {
		"handler": funcref(self, "help_handler"),
		"possible": [],
		"accept_none": true
	},
	"load": {
		"handler": funcref(game.levels, "change_level"),
		"possible": game.levels.level_data.keys()
	},
	"exit": {
		"handler": funcref(self, "unpause")
	},
	"reload": {
		"handler": funcref(self, "reload_handler")
	},
	"save": {
		"handler": funcref(saves, "save")
	},
	"quit": {
		"handler": funcref(self, "quit_handler")
	},
	"inspect": {
		"handler": funcref(self, "inspect_handler"),
		"possible": game.char_data.keys(),
		"accept_none": true
	},
	"control": {
		"handler": funcref(self, "control_handler"),
		"possible": game.char_data.keys()
	},
	"respawn": {
		"handler": funcref(self, "respawn_handler")
	},
	"give_all": {
		"handler": funcref(self, "give_all_handler")
	}
}

func control_handler(character_id: String):
	game.mgmt.player_name = character_id
	reload_handler()

func inspect_handler(character_id: String=""):
	if(!game.char_data.has(character_id)):
		character_id = ""
	settings.set_setting("dev", "debug_target", character_id)
	settings.save_settings() # TODO: (DEBUG) remove, just for debugging

func reload_handler():
	game.levels.change_level(game.levels.current_level_name)

func respawn_handler():
	var spawn = game.levels.current_level.get_node_or_null("player_spawn")
	if(spawn):
		game.mgmt.player.transform = spawn.transform
	else:
		game.mgmt.player.transform = Transform.IDENTITY

func quit_handler(force: bool=false):
	if(!force):
		saves.save()
	get_tree().quit()

func help_handler(command: String="", clear_output: bool=true):
	var new_text: String = "" if clear_output else output.get_text() + '\n'
	if(command.empty()):
		new_text += "Available commands:\n" + str(commands.keys())
	else:
		var command_entry = commands.get(command)
		if(!command_entry):
			invalid_argument("help")
		new_text += "Possible arguments for '" + command + ": " + str(command_entry.get("possible", []))
	output.set_text(new_text)

func give_all_handler():
	for x in skill_data.spells.keys():
		game.mgmt.player.inventory.add_spell(x)
	game.mgmt.player.inventory.skill_points = skill_data.skills.keys().size()
	for x in skill_data.skills.keys():
		game.mgmt.player.inventory.add_skill(x)

onready var output = $"output_background/output"
onready var input = $"command_input"

var hidden: bool = true

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
	if(event.is_action_pressed("console") && get_tree().paused != hidden):
		if(hidden):
			pause()
		else:
			unpause()
		get_tree().set_input_as_handled() # todo: watch if this fix is a good solution to prevent the activation character to appear in input field (caused because _gui_input() is called after _input())

func invalid_command():
	output.set_text("Invalid command! Did you try 'help'?")

func invalid_argument(command: String):
	output.set_text("Invalid argument!")
	help_handler(command, false)

func _on_command_input_text_changed(_new_text: String):
	# todo: autocompletion and suggestions
	pass

func _on_command_input_text_entered(new_text: String):
	# todo: improve parsing and command handling; more robust and allow multiple arguments and complexer commands
	commands["help"]["possible"] = commands.keys()
	var input_strings: PoolStringArray = new_text.to_lower().split(' ', false)
	if(input_strings.empty()):
		return
	var command = commands.get(input_strings[0])
	if(!command):
		invalid_command()
		return
	var handler = command.get("handler")
	if(!handler):
		output.set_text("Internal error: no command handler found!")
		return
	var possible_args = command.get("possible")
	var accept_none = command.get("accept_none")
	if(input_strings.size() < 2 && (accept_none || !possible_args || possible_args.empty())):
		handler.call_func()
	elif(input_strings.size() > 1 && possible_args.has(input_strings[1])):
		handler.call_func(input_strings[1])
	else:
		invalid_argument(input_strings[0])
		return
	input.clear()
