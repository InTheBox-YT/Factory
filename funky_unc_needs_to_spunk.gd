extends Node3D

var scene = preload("res://sub_viewport_container.tscn").instantiate()
#var cur_scene = preload("res://funky unc needs to spunk.tscn")
#var tree = get_tree()


@onready var control = $CanvasLayer/Control

func _on_button_pressed() -> void:
	get_tree().root.add_child(scene)
#	get_tree().root.remove_child(cur_scene)
	control.hide()
	
