extends Area3D


func _on_area_entered(_area: Area3D) -> void:
	get_node("LoadingScreen").loadLevel("res://Scenes/Day1.tscn")
	print("YES!")
