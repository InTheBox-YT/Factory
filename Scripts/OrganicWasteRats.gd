extends Area3D

@export var required_rat_count: int = 1
var rat_objects: Array[Node3D] = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("rat") and body not in rat_objects:
		rat_objects.append(body)
		check_quota()

func _on_body_exited(body: Node3D) -> void:
	if body in rat_objects:
		rat_objects.erase(body)

func check_quota():
	if rat_objects.size() >= required_rat_count:
		for rat in rat_objects:
			rat.queue_free()
		rat_objects.clear()
		print("Quota reached! Scraps deleted.")
