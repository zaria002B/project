extends Area3D
@onready var omni_light_3d: OmniLight3D = $"../OmniLight3D"

var switch =false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: CharacterBody3D) -> void:
	switch=true
	omni_light_3d.visible=switch
