extends RigidBody3D

@export var move_force: float = 5.0
@export var move_interval: float = 2.0
@export var max_speed: float = 3.0

var move_direction: Vector3 = Vector3.ZERO
var time_until_change: float = 0.0

func _ready():
	randomize()
	time_until_change = move_interval
	

func _physics_process(delta: float) -> void:
	time_until_change -= delta
	if time_until_change <= 0.0:
		_change_direction()
		time_until_change = move_interval

	if linear_velocity.length() < max_speed:
		apply_central_force(move_direction * move_force)

func _change_direction() -> void:
	var angle = randf() * TAU
	move_direction = Vector3(cos(angle), 0, sin(angle)).normalized()
