extends ScrollContainer

func _ready():
	$"layout/master_volume/master_volume_slider".set_value(settings.get_setting("sound", "master_volume"))
	$"layout/music_volume/music_volume_slider".set_value(settings.get_setting("sound", "music_volume"))

func _on_master_volume_value_changed(value: float):
	settings.set_setting("sound", "master_volume", value)
	sound_settings.set_master_volume(value)

func _on_music_volume_value_changed(value: float):
	settings.set_setting("sound", "music_volume", value)
	sound_settings.set_music_volume(value)
