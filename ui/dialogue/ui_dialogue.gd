extends Popup

class_name ui_dialogue

onready var text: RichTextLabel = $"text"
onready var name_text: Label = $"name_background/name"
onready var answer_up: RichTextLabel = $"answer_up"
onready var answer: RichTextLabel = $"answer"
onready var answer_down: RichTextLabel = $"answer_down"

var selected_answer: int = 0
var answer_ids: Array

func _unhandled_key_input(event: InputEventKey):
	if(!is_visible()):
		return

	if(event.is_action_pressed("ui_down")):
		change_selected_answer(1, true)
	elif(event.is_action_pressed("ui_up")):
		change_selected_answer(-1, true)
	elif(event.is_action_pressed("ui_accept")):
		if(answer_ids.empty() || text.get_visible_characters() >= 0):
			set_dialogue_progress(-1)
		# todo: remove? (moved to character)
	elif(event.is_action_pressed("ui_page_down")):
		change_selected_answer(answer_ids.size() - 1)
	elif(event.is_action_pressed("ui_page_up")):
		change_selected_answer(0)

func change_selected_answer(num: int, offset: bool=false):
	set_dialogue_progress(-1)
	num = selected_answer + num if offset else num
	if(num >= answer_ids.size()):
		num = answer_ids.size() - 1
	elif(num < 0):
		num = 0
	if(num - 1 >= 0):
		answer_up.text = "> " + answer_ids[num-1]#.formatted_text()
	else:
		answer_up.text = ""
	if(!answer_ids.empty()):
		answer.text = "* " + answer_ids[num]#.formatted_text()
	else:
		answer.text = ""
	if(num + 1 < answer_ids.size()):
		answer_down.text = "> " + answer_ids[num+1]#.formatted_text()
	else:
		answer_down.text = ""
	selected_answer = num

func set_answer_visible(is_visible: bool):
	answer_up.set_visible(is_visible)
	answer.set_visible(is_visible)
	answer_down.set_visible(is_visible)

func set_dialogue_text(say_text: String, speaker: String, answers: Array=[]):
	name_text.set_text(speaker)
	text.set_bbcode(say_text)
	answer_ids = answers
	set_answer_visible(!answer_ids.empty())
	change_selected_answer(0)
	text.set_visible_characters(0)

func get_current_answer_id() -> String:
	if(answer_ids.empty()):
		return "" # todo: refactor answer system
	return answer_ids[selected_answer]

func update_dialogue(visible_chars: int, transparency: float):
	set_transparency(transparency)
	set_dialogue_progress(visible_chars)

func set_dialogue_progress(progress: int):
	var text_length = text.get_total_character_count()
	if(progress < text_length && progress >= 0):
		text.set_visible_characters(progress)
		set_answer_visible(false)
	else:
		text.set_visible_characters(-1)
		set_answer_visible(true)

func set_transparency(percentage: float):
	set_modulate(Color(1, 1, 1, percentage))
