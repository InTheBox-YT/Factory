extends Area3D


func _on_area_entered(_area: Area3D) -> void:
	#get_node("LoadingScreen").loadLevel("res://Scenes/Day1.tscn")
	#print("YES!")
	var loading_scene = preload("res://Scenes/LoadingScreen.tscn").instantiate()
	add_child(loading_scene)
	loading_scene.load_level("res://Scenes/Day1.tscn")
	
