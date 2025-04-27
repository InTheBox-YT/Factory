extends StaticBody3D

@export var rigidbody_scene: PackedScene

@export var spawn_amount: int = 10
@export var spawn_rate: float = 10

@export var spawn_count: int = 0
@export var spawn_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if spawn_count >= spawn_amount:
		return
		
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_rigidbody()
		spawn_timer = spawn_rate

func spawn_rigidbody() -> void:
	if rigidbody_scene == null:
		push_warning("NO RIGID BODY HERE U STINKY")
		return
		
	var instance = rigidbody_scene.instantiate()
	instance.global_transform.origin = global_transform.origin
	
	get_tree().current_scene.add_child(instance)
	
	spawn_count += 1
