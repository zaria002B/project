extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Head/Camera3D/hands/AnimationPlayer

## Can we move around?
@export var can_move: bool = true
## Are we affected by gravity?
@export var has_gravity: bool = true
## Can we press to jump?
@export var can_jump: bool = true
## Can we hold to run?
@export var can_sprint: bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly: bool = false

@export_group("Speeds")
@export var look_speed: float = 0.002
@export var base_speed: float = 4.0
@export var jump_velocity: float = 5.5
@export var sprint_speed: float = 10.0
@export var freefly_speed: float = 25.0

@export_group("Input Actions")
@export var input_left: String = "ui_left"
@export var input_right: String = "ui_right"
@export var input_forward: String = "ui_up"
@export var input_back: String = "ui_down"
@export var input_jump: String = "ui_accept"
@export var input_sprint: String = "sprint"
@export var input_freefly: String = "freefly"

var mouse_captured: bool = false
var look_rotation: Vector2
var move_speed: float = 0.0
var freeflying: bool = false

@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider


func _ready() -> void:
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	animation_player.animation_finished.connect(_on_animation_finished)
	play_animation("IDEL")


func _unhandled_input(event: InputEvent) -> void:

	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()

	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)

	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()


func _physics_process(delta: float) -> void:

	# Freefly
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(
			input_left,
			input_right,
			input_forward,
			input_back
		)

		var motion := (
			head.global_basis *
			Vector3(input_dir.x, 0, input_dir.y)
		).normalized()

		motion *= freefly_speed * delta
		move_and_collide(motion)

		return

	# Gravity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Jump
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Movement input
	var input_dir := Input.get_vector(
		input_left,
		input_right,
		input_forward,
		input_back
	)

	# Sprint
	if can_sprint and Input.is_action_pressed(input_sprint) and input_dir != Vector2.ZERO:
		move_speed = sprint_speed
		play_animation("sprint")
	else:
		move_speed = base_speed

		if animation_player.current_animation == "sprint":
			play_animation("IDEL")
	# Movement
	if can_move:

		var move_dir := (
			transform.basis *
			Vector3(input_dir.x, 0, input_dir.y)
		).normalized()

		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)

	else:
		velocity.x = 0
		velocity.y = 0

	# ------------------------------------------------
	# HAND ANIMATIONS
	# ------------------------------------------------

	if Input.is_action_just_pressed("grab"):
		play_animation("grab")

	elif Input.is_action_just_pressed("place"):
		play_animation("place")

	elif Input.is_action_just_pressed("Invent_check"):
		play_animation("invent_check")
		



	move_and_slide()


# ==================================================
# ANIMATION FUNCTION
# ==================================================

func play_animation(animation_name: String) -> void:

	if not animation_player.has_animation(animation_name):
		push_warning("Animation not found: " + animation_name)
		return

	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != "IDEL":
		play_animation("IDEL")
# ==================================================
# LOOK
# ==================================================

func rotate_look(rot_input: Vector2):

	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(
		look_rotation.x,
		deg_to_rad(-85),
		deg_to_rad(85)
	)

	look_rotation.y -= rot_input.x * look_speed

	transform.basis = Basis()
	rotate_y(look_rotation.y)

	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


# ==================================================
# FREEFLY
# ==================================================

func enable_freefly():

	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO


func disable_freefly():

	collider.disabled = false
	freeflying = false


# ==================================================
# MOUSE
# ==================================================

func capture_mouse():

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


# ==================================================
# INPUT CHECK
# ==================================================

func check_input_mappings():

	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false

	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false

	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false

	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false

	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false

	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false

	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
