extends Area3D


func _on_area_entered(area: Area3D) -> void:
	var loading_scene = preload("res://Scenes/LoadingScreen.tscn").instantiate()
	add_child(loading_scene)
	loading_scene.load_level("res://Scenes/Day2.tscn")
