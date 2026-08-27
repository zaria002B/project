extends Control

@onready var label: Label = $Control/Label


func _ready() -> void:
	visible = false


func refresh() -> void:
	label.text = "Inventory: " + str(Inventory.items)


func show_inventory() -> void:
	refresh()
	visible = true


func hide_inventory() -> void:
	visible = false
