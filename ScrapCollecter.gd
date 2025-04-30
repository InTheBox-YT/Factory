extends Area3D

@export var required_scrap_count: int = 5
var scrap_objects: Array[Node3D] = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("scrap") and body not in scrap_objects:
		scrap_objects.append(body)
		check_quota()

func _on_body_exited(body: Node3D) -> void:
	if body in scrap_objects:
		scrap_objects.erase(body)

func check_quota():
	if scrap_objects.size() >= required_scrap_count:
		for scrap in scrap_objects:
			scrap.queue_free()
		scrap_objects.clear()
		print("Quota reached! Scraps deleted.")
