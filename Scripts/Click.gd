extends Node3D

@onready var mesh: MeshInstance3D = $MagnetArm

var original_scale: Vector3
var pop_scale: Vector3
var pop_timer := 0.0
var pop_duration := 0.5 

func _ready():
	original_scale = mesh.scale
	pop_scale = original_scale * 1.2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pop_timer = pop_duration  
func _process(delta: float) -> void:
	if pop_timer > 0.0:
		pop_timer -= delta
		var t := 1.0 - (pop_timer / pop_duration)  
		var eased := 1.0 - pow(1.0 - t, 3)
		mesh.scale = pop_scale.lerp(original_scale, eased)
	else:
		mesh.scale = original_scale
