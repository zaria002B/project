extends Node

var items: Array = []

func add_item(item_name: String) -> void:
	items.append(item_name)
	print("Picked up: ", item_name)
	print("Inventory now: ", items)
	
func remove_last_item() -> String:
	if items.size() == 0:
		return ""
	var item_name = items.pop_back()
	print("Took out: ", item_name)
	print("Inventory now: ", items)
	return item_name
