class_name InventoryComponent
extends Node

## Manages a simple dictionary-based inventory for items (Toys, Batteries, etc.).

## Emitted when an item is added to the inventory.
signal item_added(item_type: String, amount: int, total: int)

## Emitted when an item is removed from the inventory.
signal item_removed(item_type: String, amount: int, total: int)

## Internal storage: { "item_name": count }
var _items: Dictionary = {}

## Adds a specific amount of an item to the inventory.
func add_item(item_type: String, amount: int = 1) -> void:
	if not _items.has(item_type):
		_items[item_type] = 0
	
	_items[item_type] += amount
	item_added.emit(item_type, amount, _items[item_type])
	print("Inventory: Added %d %s. Total: %d" % [amount, item_type, _items[item_type]])

## Removes a specific amount of an item from the inventory.
## Returns true if the operation was successful.
func remove_item(item_type: String, amount: int = 1) -> bool:
	if not _items.has(item_type) or _items[item_type] < amount:
		return false
	
	_items[item_type] -= amount
	item_removed.emit(item_type, amount, _items[item_type])
	print("Inventory: Removed %d %s. Total: %d" % [amount, item_type, _items[item_type]])
	return true

## Checks if the inventory has at least the required amount of an item.
func has_item(item_type: String, amount: int = 1) -> bool:
	return _items.has(item_type) and _items[item_type] >= amount

## Returns the current count of a specific item.
func get_item_count(item_type: String) -> int:
	return _items.get(item_type, 0)
