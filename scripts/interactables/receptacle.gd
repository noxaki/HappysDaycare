class_name Receptacle
extends Interactable

## An object that requires items to trigger an event (e.g., a Toy Slot).

## Emitted when the required items are successfully provided.
signal requirements_met

@export_group("Requirement Settings")
@export var required_item: String = "toy"
@export var required_amount: int = 1
@export var consumes_items: bool = true

var is_satisfied: bool = false

func interact(interactor: Node3D) -> void:
	if is_satisfied:
		print("Receptacle: Already satisfied.")
		return

	var inventory: InventoryComponent = interactor.get_node_or_null("InventoryComponent")
	if not inventory:
		for child in interactor.get_children():
			if child is InventoryComponent:
				inventory = child
				break

	if inventory and inventory.has_item(required_item, required_amount):
		if consumes_items:
			inventory.remove_item(required_item, required_amount)
		
		is_satisfied = true
		requirements_met.emit()
		super.interact(interactor)
		print("Receptacle: Requirements met!")
	else:
		_on_requirements_not_met()

func _on_requirements_not_met() -> void:
	# Play 'denied' sound or feedback
	print("Receptacle: Missing items. Needs %d %s." % [required_amount, required_item])
