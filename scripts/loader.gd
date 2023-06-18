extends Node

# todo: improve loader design in general, increase robustness; maybe use signals instead of callbacks?

var _loading_scene: PackedScene = preload("res://menu/loading/loading.tscn")
var _loading_instance: Control
var _load_thread
var _finished_resources: Dictionary = {}
var _load_queue: Array = []
var _queue_mutex: Mutex = Mutex.new()
var _finished_mutex: Mutex = Mutex.new()

class OngoingResourceRequest:
	var path: String
	var progress: float
	var callback: Callable
	var latest_status: ResourceLoader.ThreadLoadStatus

	func _init(new_path: String, new_callback: Callable):
		path = new_path
		callback = new_callback

	func update():
		var current_progress: Array = []
		latest_status = ResourceLoader.load_threaded_get_status(path, current_progress)
		if(!current_progress.is_empty()):
			progress = current_progress[0]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _load_resource(path: String, callback: Callable=Callable()):
	if(_finished_resources.has(path)):
		return
	if(ResourceLoader.has_cached(path)):
		_finished_resources[path] = ResourceLoader.load(path)
		return
	var new_request_error: Error = ResourceLoader.load_threaded_request(path)
	errors.assert_always(new_request_error == OK, "Unable to load " + path + "; error: " + str(new_request_error))
	_queue_mutex.lock()
	_load_queue.push_back(OngoingResourceRequest.new(path, callback))
	_queue_mutex.unlock()

func load_resource(path: String, callback: Callable, loading_screen: bool):
	if(loading_screen):
		open_loading_screen()
	_load_resource(path, callback)
	if(!_load_thread):
		_load_thread = Thread.new()
		_load_thread.start(Callable(self, "_thread_process"))
	set_process(true)

func open_loading_screen():
	if(_loading_instance):
		return
	_loading_instance = _loading_scene.instantiate()
	scenes.open_scene(_loading_instance)
	get_tree().paused = true

func close_loading_screen():
	if(_loading_instance):
		if(scenes.current_scene == _loading_instance):
			scenes.close_scene()
		else:
			scenes.previous_scenes.erase(_loading_instance)
		_loading_instance = null
		get_tree().paused = false

func _process(_delta: float):
	if(_load_queue.is_empty() && _load_thread):
		_load_thread.wait_to_finish()
		_load_thread = null
		close_loading_screen()
		set_process(false)
		for x in _finished_resources.values():
			x[1].call(x[0])
		_finished_resources.clear()
	elif(_loading_instance):
		var current_progress: float = 0.0
		_queue_mutex.lock()
		for x in _load_queue:
			x.update()
			current_progress *= x.progress
		_queue_mutex.unlock()
		_loading_instance.set_progress(current_progress)

func _thread_process():
	while !_load_queue.is_empty():
		_queue_mutex.lock()
		var current_request: OngoingResourceRequest = _load_queue.front()
		_queue_mutex.unlock()
		match current_request.latest_status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				pass
			ResourceLoader.THREAD_LOAD_LOADED:
				_finished_mutex.lock()
				_finished_resources[current_request.path] = [ResourceLoader.load_threaded_get(current_request.path), current_request.callback]
				_finished_mutex.unlock()
				_load_queue.pop_front()
			ResourceLoader.THREAD_LOAD_FAILED:
				errors.error("loading - failed to load resource: " + current_request.path)
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				errors.error("loading - invalid resource: " + current_request.path)
			_:
				errors.error("loading - unknown error while loading resource: " + current_request.path)
