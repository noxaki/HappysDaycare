extends State

## State for when the player is in a cutscene.
## Disables movement and standard interaction.

@onready var player: PlayerController = owner

func enter(_msg := {}) -> void:
	player.velocity = Vector3.ZERO
	# Optionally disable the interaction component here if needed
	print("Player: Entered Cutscene State")

func physics_update(delta: float) -> void:
	# Only apply gravity, no movement input processed
	player.apply_gravity(delta)
	player.apply_velocity()

func handle_input(_event: InputEvent) -> void:
	# Consume input to prevent movement/jumping
	pass
