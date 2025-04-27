extends StaticBody3D

@export var rigidbody_scene: PackedScene
@export var max_spawned: int = 10
@export var spawn_rate: float = 1.0

var active_rigidbodies: Array[Node3D] = []
var spawn_timer: float = 0.0
var can_spawn: bool = false
var current_scene: Node

func _ready() -> void:
	can_spawn = true
	current_scene = get_tree().current_scene

func _physics_process(delta: float) -> void:
	if not can_spawn:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0.0 and active_rigidbodies.size() < max_spawned:
		spawn_rigidbody()
		spawn_timer = spawn_rate

func spawn_rigidbody() -> void:
	if rigidbody_scene:
		var instance: Node3D = rigidbody_scene.instantiate()
		current_scene.add_child(instance)
		instance.global_transform.origin = global_transform.origin
		active_rigidbodies.append(instance)
		instance.tree_exited.connect(_on_rigidbody_removed.bind(instance))

func _on_rigidbody_removed(instance: Node) -> void:
	active_rigidbodies.erase(instance)
