extends Node3D


# ==================================================
# REFERENCES
# ==================================================

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var placement_area: Area3D = $PlacementArea

@onready var lily_position: Marker3D = $ItemPositions/LilyPosition
@onready var excalibur_position: Marker3D = $ItemPositions/ExcaliburPosition
@onready var crystal_position: Marker3D = $ItemPositions/CrystalPosition


# ==================================================
# VARIABLES
# ==================================================

var player_near_tree: bool = false
var player: CharacterBody3D = null

var lily_placed: bool = false
var excalibur_placed: bool = false
var crystal_placed: bool = false


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	if not animation_player.animation_finished.is_connected(_on_animation_finished):
		animation_player.animation_finished.connect(_on_animation_finished)

	add_to_group("grove_restoration")

	print("================================")
	print("TREE REGISTERED AS GROVE RESTORATION")
	print("================================")


# ==================================================
# CHECK IF PLAYER IS INSIDE PLACEMENT AREA
# ==================================================

func is_player_near(player_body: CharacterBody3D) -> bool:

	if player_body == null:
		return false

	if not is_instance_valid(placement_area):
		return false

	return placement_area.has_overlapping_bodies() and \
		placement_area.get_overlapping_bodies().has(player_body)


# ==================================================
# PLAYER ENTERS PLACEMENT AREA
# ==================================================

func _on_placement_area_body_entered(body: Node3D) -> void:

	print("PlacementArea detected: ", body.name)

	if body.is_in_group("player"):

		player = body as CharacterBody3D
		player_near_tree = true

		print("================================")
		print(">>> PLAYER IS NEAR TREE")
		print("================================")


# ==================================================
# PLAYER LEAVES PLACEMENT AREA
# ==================================================

func _on_placement_area_body_exited(body: Node3D) -> void:

	if body == player:

		player = null
		player_near_tree = false

		print(">>> PLAYER LEFT TREE")


# ==================================================
# TRY TO PLACE ITEM
# ==================================================

func try_place_item(player_body: CharacterBody3D) -> void:

	print("================================")
	print("TRY PLACE ITEM")
	print("================================")

	if player_body == null:
		print("ERROR: Player is null!")
		return

	# IMPORTANT:
	# Check the actual PlacementArea.
	if not is_player_near(player_body):

		print("Player is NOT inside PlacementArea.")
		return

	# Make sure player is holding something
	if player_body.grabbed_object == null:

		print("Player is not carrying anything.")
		return

	var item: RigidBody3D = player_body.grabbed_object

	print("Carrying item: ", item.name)


	# ==================================================
	# LILY
	# ==================================================

	if item.is_in_group("quest_lily"):

		if lily_placed:
			print("Lily has already been placed.")
			return

		place_lily(item, player_body)
		return


	# ==================================================
	# EXCALIBUR
	# ==================================================

	if item.is_in_group("quest_excalibur"):

		if excalibur_placed:
			print("Excalibur has already been placed.")
			return

		place_excalibur(item, player_body)
		return


	# ==================================================
	# CRYSTAL
	# ==================================================

	if item.is_in_group("quest_crystal"):

		if crystal_placed:
			print("Crystal has already been placed.")
			return

		place_crystal(item, player_body)
		return


	print("This item cannot be placed in the Tree of Life.")


# ==================================================
# PLACE LILY
# ==================================================

func place_lily(item: RigidBody3D, player_body: CharacterBody3D) -> void:

	print("================================")
	print(">>> PLACING LILY")
	print("================================")

	lily_placed = true

	player_body.release_held_object()

	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = lily_position.global_transform

	item.reparent(self, true)

	print(">>> LILY PLACED SUCCESSFULLY")

	if animation_player.has_animation("fattreeAction_001"):

		animation_player.play("fattreeAction_001")

	else:

		push_warning("fattreeAction_001 animation not found!")


# ==================================================
# PLACE EXCALIBUR
# ==================================================

func place_excalibur(item: RigidBody3D, player_body: CharacterBody3D) -> void:

	print("================================")
	print(">>> PLACING EXCALIBUR")
	print("================================")

	excalibur_placed = true

	player_body.release_held_object()

	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = excalibur_position.global_transform

	item.reparent(self, true)

	print(">>> EXCALIBUR PLACED SUCCESSFULLY")

	if animation_player.has_animation("fattreeAction"):

		animation_player.play("fattreeAction")

	else:

		push_warning("fattreeAction animation not found!")


# ==================================================
# PLACE CRYSTAL
# ==================================================

func place_crystal(item: RigidBody3D, player_body: CharacterBody3D) -> void:

	print("================================")
	print(">>> PLACING CRYSTAL")
	print("================================")

	crystal_placed = true

	player_body.release_held_object()

	item.freeze = true
	item.linear_velocity = Vector3.ZERO
	item.angular_velocity = Vector3.ZERO

	item.global_transform = crystal_position.global_transform

	item.reparent(self, true)

	print(">>> CRYSTAL PLACED SUCCESSFULLY")

	if animation_player.has_animation("fattreeAction_002"):

		animation_player.play("fattreeAction_002")

	else:

		push_warning("fattreeAction_002 animation not found!")


# ==================================================
# CHECK EVERYTHING
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

	if anim_name == "fattreeAction_002":

		if all_items_placed():

			print("================================")
			print("ALL THREE ITEMS HAVE BEEN PLACED!")
			print("THE TREE OF LIFE IS RESTORED!")
			print("================================")

			await get_tree().create_timer(2.0).timeout

			get_tree().change_scene_to_file(
				"res://scenes/ending.tscn"
			)
