extends Control

@onready var player: CharacterBody3D = $"../ProtoController"
@onready var rich_text: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var play_again_button: Button = $VBoxContainer/PlayAgainButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	visible = false
	modulate.a = 0.0
	play_again_button.pressed.connect(_on_play_again_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	GroveRestoration.game_completed.connect(_on_game_completed)


func _on_game_completed() -> void:
	show_completion()


func show_completion() -> void:
	visible = true
	player.can_move = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	rich_text.text = "[center][b]YOU DID IT![/b][/center]

The dungeon is quiet now — not with dread, but with peace. All %d essences have been returned, and the sacred tree stands tall once more.

Every corner you explored, every puzzle you solved, brought this forest back to life.

[i]Thanks so much for playing our game![/i]" % GroveRestoration.total_essences

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.2)


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
	
