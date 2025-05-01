extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Scrap"):
		body.set_on_base(true)

func _on_body_exited(body):
	if body.is_in_group("Scrap"):
		body.set_on_base(false)
