extends AIState

## State where Funbot actively pursues the player.

@onready var funbot: FunbotController = owner

func physics_update(delta: float) -> void:
	if funbot.player and funbot.is_player_in_range(funbot.lost_radius):
		funbot.move_towards(funbot.player.global_position, delta)
	else:
		state_machine.transition_to("Patrol")
