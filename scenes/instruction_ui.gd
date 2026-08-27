extends Control

@onready var player: CharacterBody3D = $"../../ProtoController"


func _ready() -> void:
	visible = true
	player.can_move = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if visible and event is InputEventKey and event.pressed:
		start_game()


func start_game() -> void:
	visible = false
	player.can_move = true
	player.capture_mouse()
