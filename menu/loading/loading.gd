extends Control

@onready var progress: TextureProgressBar = $"progress"

func set_progress(progress_value: float):
	progress.set_value(progress_value)
