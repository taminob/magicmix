extends Control

onready var progress: TextureProgress = $"progress"
var _loader: ResourceInteractiveLoader = null

func track_loader(loader: ResourceInteractiveLoader):
	_loader = loader

func _process(_delta: float):
	if(_loader):
		progress.set_value(float(_loader.get_stage()) / _loader.get_stage_count())
		match _loader.poll():
			ERR_FILE_EOF:
				game.finished_loading(_loader)
				_loader = null
			OK:
				pass
			_:
				errors.error("loading: unable to interactively load resource!")
