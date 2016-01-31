
extends Node

var items = []

func get_item(item):
	items.append(item)
	item.get_parent().remove_child(item)

func get_item_count():
	return items.size()

func return_item():
	var i = items[items.size()-1]
	items.pop_back()
	get_tree().get_root().get_node("world").add_child(i)