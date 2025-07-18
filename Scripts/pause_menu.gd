extends Control


func _ready() -> void:
	pause_menu.hide()
	
@onready var pause_menu = $"."

func _on_button_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		pause_menu.show()
