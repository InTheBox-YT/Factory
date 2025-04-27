extends RigidBody3D

@export var lifetime: float = 15.0

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
