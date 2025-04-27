extends StaticBody3D

@export var rigidbody_scene: PackedScene
@export var max_spawned: int = 10
@export var spawn_rate: float = 1.0

var active_rigidbodies: Array = []
var spawn_timer: float = 0.0

func _physics_process(delta: float) -> void:
	active_rigidbodies = active_rigidbodies.filter(func(body):
		return body != null and body.is_inside_tree()
	)

	if active_rigidbodies.size() < max_spawned:
		spawn_timer -= delta
		if spawn_timer <= 0.0:
			spawn_rigidbody()
			spawn_timer = spawn_rate

func spawn_rigidbody() -> void:
	if rigidbody_scene == null:
		return

	var instance = rigidbody_scene.instantiate()
	instance.global_transform.origin = global_transform.origin
	get_tree().current_scene.add_child(instance)
	instance.connect("tree_exited", Callable(self, "_on_rigidbody_removed").bind(instance))
	active_rigidbodies.append(instance)

func _on_rigidbody_removed(body: Node) -> void:
	if active_rigidbodies.has(body):
		active_rigidbodies.erase(body)
