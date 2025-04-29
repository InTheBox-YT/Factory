extends Node3D

var scene = preload("res://sub_viewport_container.tscn")
var scene2 = preload("res://funky unc needs to spunk.tscn")
var instance1 = scene.instantiate()
var instance2 = scene2.instantiate()


@onready var control = $CanvasLayer/Control

func _on_button_pressed() -> void:
	add_child(instance1)
	remove_child(instance2)
	control.hide()
	
