class_name Interactable
extends CollisionObject3D

## Base class for all interactable objects in the world.
## Can be attached to StaticBody3D or Area3D.

## Emitted when interaction starts.
signal interacted(interactor: Node3D)

## Virtual method to be overridden by subclasses.
func interact(interactor: Node3D) -> void:
	interacted.emit(interactor)
	print("%s was interacted with by %s" % [name, interactor.name])
