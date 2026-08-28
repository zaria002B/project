extends Node3D


# ==================================================
# REFERENCES
# ==================================================

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var lily_position: Marker3D = $LAND4/tree/ItemPositions/LilyPosition
@onready var excalibur_position: Marker3D = $LAND4/tree/ItemPositions/ExcaliburPosition
@onready var crystal_position: Marker3D = $LAND4/tree/ItemPositions/CrystalPosition
@onready var animation_player: AnimationPlayer = $LAND4/tree/AnimationPlayer



# ==================================================
# PLAYER
# ==================================================

var player_near_tree: bool = false
var player: CharacterBody3D = null


# ==================================================
# QUEST PROGRESS
# ==================================================

var lily_placed: bool = false
var excalibur_placed: bool = false
var crystal_placed: bool = false


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	# Make sure the animation_finished signal is connected.
	if not animation_player.animation_finished.is_connected(_on_animation_finished):
		animation_player.animation_finished.connect(_on_animation_finished)


# ==================================================
# PLAYER ENTERS TREE AREA
# ==================================================

func _on_placement_area_body_entered(body: Node3D) -> void:

	if body.is_in_group("player"):

		player = body as CharacterBody3D
		player_near_tree = true

		print("Player is near the Tree of Life.")


# ==================================================
# PLAYER LEAVES TREE AREA
# ==================================================

func _on_placement_area_body_exited(body: Node3D) -> void:

	if body.is_in_group("player"):

		player = null
		player_near_tree = false

		print("Player left the Tree of Life.")


# ==================================================
# PLACE ITEM
# ==================================================

func try_place_item() -> void:

	# Player must be near the tree.
	if player == null:
		return

	# Player must be carrying something.
	if player.grabbed_object == null:

		print("You are not carrying anything.")

		return


	# Get the object the player is carrying.
	var item: RigidBody3D = player.grabbed_object


	# ==================================================
	# LILY
	# ==================================================

	if item.is_in_group("quest_lily") and not lily_placed:

		place_lily(item)

		return


	# ==================================================
	# EXCALIBUR
	# ==================================================

	if item.is_in_group("quest_excalibur") and not excalibur_placed:

		place_excalibur(item)

		return


	# ==================================================
	# RED CRYSTAL
	# ==================================================

	if item.is_in_group("quest_crystal") and not crystal_placed:

		place_crystal(item)

		return


	print("This item cannot be placed in the Tree of Life.")


# ==================================================
# PLACE LILY
# ==================================================

func place_lily(item: RigidBody3D) -> void:

	print("Placing Lily of the Valley.")

	lily_placed = true

	# Release the object from the player's hands.
	player.release_held_object()

	# Stop physics.
	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	# Move the Lily to its position.
	item.global_transform = lily_position.global_transform

	# Make the Tree the parent.
	item.reparent(self)

	# Play Tree animation.
	if animation_player.has_animation("tree_lily"):

		animation_player.play("tree_lily")

	else:

		push_warning("Animation 'tree_lily' not found.")


# ==================================================
# PLACE EXCALIBUR
# ==================================================

func place_excalibur(item: RigidBody3D) -> void:

	print("Placing Excalibur.")

	excalibur_placed = true

	# Release from player.
	player.release_held_object()

	# Stop physics.
	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	# Move to Tree.
	item.global_transform = excalibur_position.global_transform

	# Make Tree the parent.
	item.reparent(self)

	# Play animation.
	if animation_player.has_animation("tree_excalibur"):

		animation_player.play("tree_excalibur")

	else:

		push_warning("Animation 'tree_excalibur' not found.")


# ==================================================
# PLACE RED CRYSTAL
# ==================================================

func place_crystal(item: RigidBody3D) -> void:

	print("Placing Red Crystal.")

	crystal_placed = true

	# Release from player.
	player.release_held_object()

	# Stop physics.
	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	# Move to Tree.
	item.global_transform = crystal_position.global_transform

	# Make Tree the parent.
	item.reparent(self)

	# Play animation.
	if animation_player.has_animation("tree_crystal"):

		animation_player.play("tree_crystal")

	else:

		push_warning("Animation 'tree_crystal' not found.")


# ==================================================
# CHECK FINAL QUEST
# ==================================================

func all_items_placed() -> bool:

	return (
		lily_placed
		and excalibur_placed
		and crystal_placed
	)


# ==================================================
# ANIMATION FINISHED
# ==================================================

func _on_animation_finished(anim_name: StringName) -> void:

	print("Finished animation: ", anim_name)


	# If the final crystal animation finished,
	# all three items have now been placed.

	if anim_name == "tree_crystal":

		if all_items_placed():

			print("ALL THREE ITEMS HAVE BEEN PLACED!")
			print("The Tree of Life has been restored!")

			# Small delay before ending scene.
			await get_tree().create_timer(2.0).timeout

			get_tree().change_scene_to_file(
				"res://scenes/ending.tscn"
			)
