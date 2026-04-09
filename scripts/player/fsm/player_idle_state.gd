extends State

## State for when the player is stationary on the floor.

@onready var player: PlayerController = owner

func enter(_msg := {}) -> void:
	player.velocity.x = 0
	player.velocity.z = 0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	var input_dir := player.get_move_input()
	
	if input_dir.length() > 0:
		state_machine.transition_to("Walk")
		return
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
		return
	
	# Apply friction/deceleration
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.friction * delta)
	
	player.apply_velocity()
