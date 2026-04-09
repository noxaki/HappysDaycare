class_name FunbotController
extends CharacterBody3D

## Controller for the Funbot enemy.

@export_group("Movement Settings")
@export var speed: float = 4.0
@export var acceleration: float = 15.0

@export_group("Detection Settings")
@export var detection_radius: float = 10.0
@export var lost_radius: float = 15.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine: AIStateMachine = $StateMachine

var player: Node3D = null

func _ready() -> void:
	# Wait for the first physics frame so the NavigationServer can sync
	set_physics_process(false)
	call_deferred("_setup_ai")

func _setup_ai() -> void:
	await get_tree().physics_frame
	set_physics_process(true)
	
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Funbot: Player not found in 'player' group.")
	
	# Check if we are on a NavMesh
	var current_map = get_world_3d().get_navigation_map()
	var closest_point = NavigationServer3D.map_get_closest_point(current_map, global_position)
	if global_position.distance_to(closest_point) > 1.0:
		push_error("Funbot: Not placed on a valid NavigationMesh! Movement will fail.")

func is_player_in_range(radius: float) -> bool:
	if not player: return false
	return global_position.distance_to(player.global_position) < radius

func move_towards(target_position: Vector3, delta: float) -> void:
	nav_agent.target_position = target_position
	
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()
	
	# Only move if we aren't already at the target
	if not nav_agent.is_navigation_finished():
		var new_velocity = direction * speed
		velocity = velocity.lerp(new_velocity, acceleration * delta)
		move_and_slide()
		
		# Smoother rotation
		if velocity.length() > 0.1:
			var look_target = global_position + Vector3(velocity.x, 0, velocity.z)
			var look_transform = transform.looking_at(look_target, Vector3.UP)
			transform = transform.interpolate_with(look_transform, 10.0 * delta)
