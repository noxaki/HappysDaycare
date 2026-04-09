extends State

## State for when the player is in the air.

@onready var player: PlayerController = owner

func enter(_msg := {}) -> void:
	player.velocity.y = player.jump_velocity

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	var input_dir := player.get_move_input()
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Limited air control
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction.x * player.walk_speed, player.acceleration * 0.5 * delta)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.walk_speed, player.acceleration * 0.5 * delta)
	
	player.apply_velocity()
	
	if player.is_on_floor():
		state_machine.transition_to("Idle")
