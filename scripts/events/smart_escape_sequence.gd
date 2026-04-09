class_name SmartEscapeSequence
extends Area3D

## Orchestrates the "Smart Escape" sequence.
## Disables player input, moves camera, forces AI to a trap.

@export_group("Nodes")
@export var player: PlayerController
@export var funbot: FunbotController
@export var trap_marker: Marker3D
@export var hiding_spot: Marker3D
@export var scream_audio: AudioStreamPlayer3D

@export_group("Settings")
@export var shake_intensity: float = 0.5
@export var shake_duration: float = 1.0

var is_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if is_triggered: return
	
	if body.is_in_group("player") or body == player:
		_start_sequence()

func _start_sequence() -> void:
	is_triggered = true
	print("Sequence: Starting Smart Escape!")

	# 1. Lock Player
	if player:
		player.state_machine.transition_to("Cutscene")
		
		# 2. Move Camera to Hiding Spot (simple snap for now)
		if hiding_spot:
			var tween = create_tween()
			tween.tween_property(player.camera, "global_position", hiding_spot.global_position, 0.5)
			tween.parallel().tween_property(player.camera, "global_rotation", hiding_spot.global_rotation, 0.5)

	# 3. Force Funbot to Trap
	if funbot:
		var scripted_state = funbot.state_machine.get_node("Scripted")
		funbot.state_machine.transition_to("Scripted", {"target_pos": trap_marker.global_position})
		
		# 4. Wait for Funbot to reach trap
		scripted_state.destination_reached.connect(_on_funbot_reached_trap, CONNECT_ONE_SHOT)

func _on_funbot_reached_trap() -> void:
	print("Sequence: Funbot reached trap!")
	
	# 5. Effects
	if scream_audio:
		scream_audio.play()
	
	_apply_camera_shake()
	
	# Wait for effects to finish, then restore player control
	await get_tree().create_timer(shake_duration + 1.0).timeout
	_end_sequence()

func _end_sequence() -> void:
	print("Sequence: Ended.")
	if player:
		player.state_machine.transition_to("Idle")
		# Reset camera position is usually handled by the state transitions 
		# but for a simple prototype, we might need to reset it manually
		player.camera.position = Vector3.ZERO 
		player.camera.rotation = Vector3.ZERO

func _apply_camera_shake() -> void:
	if not player or not player.camera: return
	
	var original_pos = player.camera.position
	var tween = create_tween()
	
	for i in range(10):
		var offset = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0) * shake_intensity
		tween.tween_property(player.camera, "position", original_pos + offset, 0.05)
	
	tween.tween_property(player.camera, "position", original_pos, 0.05)
