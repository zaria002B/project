extends Node3D



@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var lily_position: Marker3D = $ItemPositions/LilyPosition
@onready var excalibur_position: Marker3D = $ItemPositions/ExcaliburPosition
@onready var crystal_position: Marker3D = $ItemPositions/CrystalPosition



var player_near_tree: bool = false
var player: CharacterBody3D = null



var lily_placed: bool = false
var excalibur_placed: bool = false
var crystal_placed: bool = false


func _ready() -> void:

	audio_stream_player.play()



func _on_placement_area_body_entered(body: Node3D) -> void:

	if body.is_in_group("player"):

		player = body as CharacterBody3D
		player_near_tree = true

		print("Player is near the Tree of Life.")



func _on_placement_area_body_exited(body: Node3D) -> void:

	if body.is_in_group("player"):

		player = null
		player_near_tree = false

		print("Player left the Tree of Life.")



func try_place_item() -> void:

	if player == null:
		return

	if player.grabbed_object == null:

		print("You are not carrying anything.")

		return


	var item: RigidBody3D = player.grabbed_object



	if item.is_in_group("quest_lily") and not lily_placed:

		place_lily(item)

		return



	if item.is_in_group("quest_excalibur") and not excalibur_placed:

		place_excalibur(item)

		return



	if item.is_in_group("quest_crystal") and not crystal_placed:

		place_crystal(item)

		return


	print("This item cannot be placed in the Tree of Life.")


func place_lily(item: RigidBody3D) -> void:

	print("Lily of the Valley placed!")

	lily_placed = true

	player.release_held_object()

	item.freeze = true

	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = lily_position.global_transform

	item.reparent(self)

	if animation_player.has_animation("tree_lily"):

		animation_player.play("tree_lily")

	else:

		push_warning("tree_lily animation not found!")



func place_excalibur(item: RigidBody3D) -> void:

	print("Excalibur placed!")

	excalibur_placed = true

	player.release_held_object()

	item.freeze = true

	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = excalibur_position.global_transform

	item.reparent(self)

	if animation_player.has_animation("tree_excalibur"):

		animation_player.play("tree_excalibur")

	else:

		push_warning("tree_excalibur animation not found!")


func place_crystal(item: RigidBody3D) -> void:

	print("Red Crystal placed!")

	crystal_placed = true

	player.release_held_object()

	item.freeze = true

	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = crystal_position.global_transform

	item.reparent(self)

	if animation_player.has_animation("tree_crystal"):

		animation_player.play("tree_crystal")

	else:

		push_warning("tree_crystal animation not found!")



func all_items_placed() -> bool:

	return (
		lily_placed
		and excalibur_placed
		and crystal_placed
	)



func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == "tree_crystal":

		if all_items_placed():

			print("All three items have been placed!")
			print("The Tree of Life is restored!")

			await get_tree().create_timer(2.0).timeout

			get_tree().change_scene_to_file(
				"res://scenes/ending.tscn"
			)
