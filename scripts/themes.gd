extends Node

# theme, size, space_top, space_bottom, space_char, space_space, outline_size
var themes = [
	load("res://themes/menu_theme.tres"),
	load("res://themes/ui_theme.tres")
]

var attributes = {
	"VBoxContainer": {
		"separation": null
	}
}

var base_font = {}
func _scale_font(font, factor):
	var attributes = ["size", "extra_spacing_top", "extra_spacing_bottom",
	"extra_spacing_char", "extra_spacing_space", "outline_size"]
	var font_id = font.get_instance_id()
	var no_base = !base_font.has(font_id)
	if(no_base):
		base_font[font_id] = []
	for i in range(attributes.size()):
		if(no_base):
			base_font[font_id].push_back(font.get(attributes[i]))
		font.set(attributes[i], base_font[font_id][i] * factor)

func scale_themes(factor):
	for theme in themes:
		_scale_font(theme.default_font, factor)
		for type in attributes.keys():
			for font in theme.get_font_list(type):
				_scale_font(type, factor)
			for constant in attributes[type].keys():
				if(attributes[type][constant] == null):
					attributes[type][constant] = theme.get_constant(constant, type)
				theme.set_constant(constant, type, attributes[type][constant] * factor)