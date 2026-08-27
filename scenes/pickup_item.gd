extends Area3D

@export var item_name: String = "Key"


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Inventory.add_item(item_name)
		queue_free()


func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
