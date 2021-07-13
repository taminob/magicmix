extends Control

onready var progress: TextureProgress = $"progress"

func set_progress(progress_value: float):
	progress.set_value(progress_value)
