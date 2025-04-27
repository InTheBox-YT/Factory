extends StaticBody3D

@export var belt_speed: float = 5.0
@export var belt_direction: Vector3 = Vector3.FORWARD

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			move_body_along_belt(body, delta)
			
func move_body_along_belt(body: RigidBody3D, delta: float) -> void:
	var global_direction = global_transform.basis * belt_direction.normalized()
	
	var target_velocity = global_direction * belt_speed
	
	body.linear_velocity.x = lerp(body.linear_velocity.x,
	target_velocity.x,5 * delta)
	body.linear_velocity.z = lerp(body.linear_velocity.z,
	target_velocity.z,5 * delta)
	
func get_overlapping_bodies() -> Array:
	var bodies = []
	if has_node("Area3D"):
		bodies = $Area3D.get_overlapping_bodies()
	return bodies
