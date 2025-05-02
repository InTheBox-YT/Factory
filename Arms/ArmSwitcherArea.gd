extends Area3D

@export var arm_scene: PackedScene

func _on_body_entered(body):
	if body.has_method("attach_arm"): 
		body.attach_arm(arm_scene)
		queue_free() 
