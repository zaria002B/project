extends Node

var items: Array = []

func add_item(item_name: String) -> void:
	items.append(item_name)
	print("Picked up: ", item_name)
	print("Inventory now: ", items)
