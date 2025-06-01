extends RigidBody3D
@export var scrap_type: String = "ScrapCube2"
func _ready() -> void:
	add_to_group("scrap_cube")
