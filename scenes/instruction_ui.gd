extends Control
#@onready var proto_controller: CharacterBody3D = $"."


@onready var rich_text_label: RichTextLabel = $RichTextLabel


@onready var player: CharacterBody3D = $"../../player"




var pages: Array[String] = [
	"""[center][b]THE LAST GROVE[/b][/center]

The forest was once alive.

Its trees whispered with the wind, its rivers ran clear,
and the sacred grove protected all living things.

But something has changed.

The sacred tree at the heart of the forest is dying,
and with it, the life of the entire grove.

Three fragments of life remain scattered throughout
the forest.

You must find them and return them to the sacred tree.

Only then can the grove breathe again.""",

	"""[center][b]YOUR TASK[/b][/center]

Explore the forest and find the three life essences:

[b]✦ Glowing Seed[/b]
A seed carrying the remaining life of the forest.

[b]✦ Water Droplet[/b]
Pure water needed to restore the tree.

[b]✦ Firefly Lantern[/b]
A small light carrying the spirit of the grove.

Carry each essence back to the sacred tree
and place it there.

Restore all three to awaken the tree.""",

	"""[center][b]CONTROLS[/b][/center]

[b]W A S D[/b]        Move
[b]MOUSE[/b]          Look Around
[b]SPACE[/b]          Jump
[b]SHIFT[/b]          Sprint
[b]RIGHT CLICK[/b]    Pick Up
[b]LEFT CLICK[/b]     Place
[b]E[/b]              Inventory
[b]ESC[/b]            Release Mouse

[b]WARNING[/b]

Be careful near the river and ravine.

If you fall in, you will be swept away
and wake up back at the trailhead.

[center]Press any key to begin your journey.[/center]"""
]

var current_page: int = 0


func _ready() -> void:
	visible = true
	
	player.can_move = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	rich_text_label.bbcode_enabled = true
	rich_text_label.text = pages[current_page]


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		show_next_page()


func show_next_page() -> void:
	current_page += 1
	
	if current_page < pages.size():
		rich_text_label.text = pages[current_page]
	else:
		start_game()


func start_game() -> void:
	visible = false
	player.can_move = true
	player.capture_mouse()
