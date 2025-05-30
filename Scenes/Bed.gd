extends Area3D

func _on_area_entered(_area: Area3D) -> void:
	var loading_scene = preload("res://Scenes/LoadingScreen.tscn").instantiate()
	add_child(loading_scene)      #On Area Entered call the loading screen script to switch scenes
	loading_scene.load_level("res://Day1Shader.tscn")
	print("Day 1 Loaded")
