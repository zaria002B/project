extends Node

var restored_count: int = 0
var total_essences: int = 3

func _ready():
	print("Grove Restoration System Ready!")
	
func restore_essence():
	restored_count += 1
	
	print("Grove restoration: ", restored_count, "/", total_essences)
	
	if restored_count == 1:
		first_restoration()
	elif restored_count == 2:
		second_restoration()
	elif restored_count == 3:
		final_restoration()


func first_restoration():
	print("The grove begins to awaken!")


func second_restoration():
	print("More life returns to the forest!")


func final_restoration():
	print("The sacred tree has fully awakened!")


func _on_sacred_tree_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("Player is near the sacred tree!")
