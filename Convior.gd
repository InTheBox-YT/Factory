extends StaticBody3D

@export var belt_speed: float = 5.0
@export var belt_direction: Vector3 = Vector3.FORWARD
@onready var belt_area: Area3D = $Area3D

func _physics_process(delta: float) -> void:
	if belt_area:
		var global_direction = global_transform.basis * belt_direction.normalized()
		var target_velocity = global_direction * belt_speed

		for body in belt_area.get_overlapping_bodies():
			if body is RigidBody3D:
				body.linear_velocity.x = lerp(body.linear_velocity.x, target_velocity.x, 5.0 * delta)
				body.linear_velocity.z = lerp(body.linear_velocity.z, target_velocity.z, 5.0 * delta)
