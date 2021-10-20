extends Popup

class_name ui_dialogue

onready var text: RichTextLabel = $"text"
onready var name_text: Label = $"name_background/name"
onready var answer_up: RichTextLabel = $"answer_up"
onready var answer: RichTextLabel = $"answer"
onready var answer_down: RichTextLabel = $"answer_down"

var selected_response: int = 0
var responses: Array

func _unhandled_key_input(event: InputEventKey):
	if(!is_visible()):
		return

	if(event.is_action_pressed("ui_down")):
		change_selected_answer(1, true)
	elif(event.is_action_pressed("ui_up")):
		change_selected_answer(-1, true)
	elif(event.is_action_pressed("ui_accept")):
		if(responses.empty() || text.get_visible_characters() >= 0):
			set_progress(-1)
		# todo: remove? (moved to character)
	elif(event.is_action_pressed("ui_page_down")):
		change_selected_answer(responses.size() - 1)
	elif(event.is_action_pressed("ui_page_up")):
		change_selected_answer(0)

func change_selected_answer(num: int, offset: bool=false):
	set_progress(-1)
	num = selected_response + num if offset else num
	if(num >= responses.size()):
		num = responses.size() - 1
	elif(num < 0):
		num = 0
	if(num - 1 >= 0):
		answer_up.text = "> " + responses[num-1].formatted_text()
	else:
		answer_up.text = ""
	if(!responses.empty()):
		answer.text = "* " + responses[num].formatted_text()
	else:
		answer.text = ""
	if(num + 1 < responses.size()):
		answer_down.text = "> " + responses[num+1].formatted_text()
	else:
		answer_down.text = ""
	selected_response = num

func set_answer_visible(is_visible: bool):
	answer_up.set_visible(is_visible)
	answer.set_visible(is_visible)
	answer_down.set_visible(is_visible)

func set_dialogue_text(say_text: String, speaker: String, new_responses: Array=[]):
	name_text.set_text(speaker)
	text.set_bbcode(say_text)
	responses = new_responses
	change_selected_answer(0)
	set_progress(0)

func get_current_response() -> String:
	if(responses.empty()):
		return "" # todo: refactor answer system
	return responses[selected_response]

func update_dialogue(visible_chars: int, transparency: float):
	set_transparency(transparency)
	set_progress(visible_chars)

const DIALOGUE_SPEED = 20
var progress: float = 0.0
func _process(delta: float):
	if(fully_visible()):
		return
	var text_length: int = text.get_total_character_count()
	if(text_length > 0):
		progress += DIALOGUE_SPEED * delta
		set_progress(progress if progress < text_length else -1)

func set_progress(new_progress: float):
	progress = new_progress
	text.set_visible_characters(progress)
	set_answer_visible(progress < 0)

func fully_visible() -> bool:
	return text.get_visible_characters() < 0

func set_transparency(percentage: float):
	set_modulate(Color(1, 1, 1, percentage))
