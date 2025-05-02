extends Area3D

@export var crafted_item_scene: PackedScene

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node3D) -> void:
	if body.name.begins_with("ScrapCube") or body.is_in_group("scrap_cube"):
		if crafted_item_scene:
			var new_item = crafted_item_scene.instantiate()
			new_item.global_transform = body.global_transform 
			get_tree().current_scene.add_child(new_item)
			body.queue_free()

func set_crafted_item(new_scene: PackedScene) -> void:
	crafted_item_scene = new_scene
