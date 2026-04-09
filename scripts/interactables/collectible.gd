class_name Collectible
extends Interactable

## An item that can be picked up and added to the player's inventory.

@export_group("Collectible Settings")
@export var item_type: String = "toy"
@export var amount: int = 1

func interact(interactor: Node3D) -> void:
	# Look for InventoryComponent on the interactor or its children
	var inventory: InventoryComponent = interactor.get_node_or_null("InventoryComponent")
	
	if not inventory:
		# Fallback: search children if interactor is the PlayerController but inventory is a child
		for child in interactor.get_children():
			if child is InventoryComponent:
				inventory = child
				break
	
	if inventory:
		inventory.add_item(item_type, amount)
		super.interact(interactor) # Emit base signal
		_on_collected()
	else:
		push_warning("Collectible: Interactor %s has no InventoryComponent." % interactor.name)

func _on_collected() -> void:
	# Play sound or effect here before freeing
	queue_free()
