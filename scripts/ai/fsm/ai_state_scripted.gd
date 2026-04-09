extends AIState

## State for moving to a specific marker during cutscenes.

signal destination_reached

@onready var funbot: FunbotController = owner
var target_pos: Vector3 = Vector3.ZERO

func enter(msg := {}) -> void:
	if msg.has("target_pos"):
		target_pos = msg["target_pos"]
	elif msg.has("target_node"):
		target_pos = msg["target_node"].global_position
	print("Funbot: Entering Scripted state, moving to ", target_pos)

func physics_update(delta: float) -> void:
	funbot.move_towards(target_pos, delta)
	
	if funbot.nav_agent.is_navigation_finished() or funbot.global_position.distance_to(target_pos) < 1.0:
		destination_reached.emit()
		# Logic to stay here or return to chase is handled by the Event Manager
