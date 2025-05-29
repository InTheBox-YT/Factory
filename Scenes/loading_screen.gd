extends Control

var loading := false
var path := ""
var wait_for_input := false

func _process(delta: float) -> void:
	if loading:
		var progress := []
		var status = ResourceLoader.load_threaded_get_status(path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print(progress[0] * 100)
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			print("Level Loaded")
			_change_scene(ResourceLoader.load_threaded_get(path))

func _change_scene(resource: PackedScene) -> void:
	var current_node = resource.instantiate()
	get_tree().root.add_child(current_node)
	
	for item in get_tree().root.get_children():
		if item != current_node:
			item.queue_free()

func load_level(new_path: String) -> void:
	path = new_path
	show()
	if ResourceLoader.exists(path):
		ResourceLoader.load_threaded_request(path, "", true)
		loading = true
