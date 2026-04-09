class_name InteractionComponent
extends RayCast3D

## Component that detects and interacts with world objects.
## Should be a child of the Camera3D.

@export var interact_action: String = "interact"

## Emitted when the looking-at state changes.
signal target_changed(new_target: Node3D)

var current_target: Node3D = null

func _process(_delta: float) -> void:
	_check_interaction()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action):
		if current_target and current_target.has_method("interact"):
			current_target.interact(owner)

func _check_interaction() -> void:
	var collider = get_collider()
	
	if collider != current_target:
		# Only consider objects that have an 'interact' method
		if collider and collider.has_method("interact"):
			current_target = collider
		else:
			current_target = null
		
		target_changed.emit(current_target)
