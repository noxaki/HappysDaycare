extends State

## State for when the player is walking on the floor.

@onready var player: PlayerController = owner

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	var input_dir := player.get_move_input()
	
	if input_dir.length() == 0:
		state_machine.transition_to("Idle")
		return
	
	if Input.is_action_pressed("run"):
		state_machine.transition_to("Run")
		return

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
		return

	# Calculate movement direction relative to player rotation
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction.x * player.walk_speed, player.acceleration * delta)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.walk_speed, player.acceleration * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.walk_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.walk_speed)
	
	player.apply_velocity()
