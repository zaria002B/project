extends Node

var restored_count: int = 0
var total_essences: int = 3
var player_near_tree: bool = false
#@onready var sacred_glow: OmniLight3D = get_tree().current_scene.get_node("SacredTree/SacredGlow")
@onready var sacred_glow: OmniLight3D = $SacredTree/SacredGlow


func _ready() -> void:
	print("player_near_tree exists? ", "player_near_tree" in self)
	print("Grove Restoration System Ready!")


func restore_essence() -> void:
	if restored_count >= total_essences:
		return
	restored_count += 1
	print("Grove restoration: ", restored_count, "/", total_essences)
	if restored_count == 1:
		first_restoration()
	elif restored_count == 2:
		second_restoration()
	elif restored_count == 3:
		final_restoration()


func first_restoration() -> void:
	print("The grove begins to awaken!")


func second_restoration() -> void:
	print("More life returns to the forest!")


func final_restoration() -> void:
	print("The sacred tree has fully awakened!")


func _on_sacred_tree_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_near_tree = true
		print("Player is near the sacred tree!")


func _on_sacred_tree_area_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_near_tree = false
		print("Player left the sacred tree area.")
