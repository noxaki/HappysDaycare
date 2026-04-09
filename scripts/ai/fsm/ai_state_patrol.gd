extends AIState

## State where Funbot patrols between a set of markers.

@export var patrol_points: Array[Node3D] = []
@export var wait_time: float = 2.0

@onready var funbot: FunbotController = owner
var current_point_index: int = 0
var is_waiting: bool = false

func enter(_msg := {}) -> void:
	if patrol_points.is_empty():
		# Fallback: find any markers in the scene if none assigned
		var markers = get_tree().get_nodes_in_group("patrol_points")
		for m in markers:
			if m is Node3D:
				patrol_points.append(m)
	
	_move_to_next_point()

func physics_update(delta: float) -> void:
	# Check for player
	if funbot.is_player_in_range(funbot.detection_radius):
		state_machine.transition_to("Chase")
		return

	if is_waiting or patrol_points.is_empty():
		return
	
	var target = patrol_points[current_point_index]
	funbot.move_towards(target.global_position, delta)
	
	if funbot.nav_agent.is_navigation_finished() or funbot.global_position.distance_to(target.global_position) < 1.0:
		_start_waiting()

func _move_to_next_point() -> void:
	if patrol_points.is_empty(): return
	current_point_index = (current_point_index + 1) % patrol_points.size()
	is_waiting = false

func _start_waiting() -> void:
	is_waiting = true
	await get_tree().create_timer(wait_time).timeout
	_move_to_next_point()
