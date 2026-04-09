class_name Door
extends Node3D

## A script for an automated door that can be triggered by signals.

@export_group("Door Settings")
@export var is_open: bool = false
@export var open_animation: String = "open"
@export var close_animation: String = "close"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Public method to be called by Receptacles or other triggers via Signal connection.
func open() -> void:
	if is_open: return
	
	if animation_player.has_animation(open_animation):
		animation_player.play(open_animation)
		is_open = true
		print("Door: Opening...")
	else:
		# Fallback: simple transform change if no animation exists
		print("Door: No open animation found. Snapping open.")
		is_open = true
		position.y += 3.0

func close() -> void:
	if not is_open: return
	
	if animation_player.has_animation(close_animation):
		animation_player.play(close_animation)
		is_open = false
		print("Door: Closing...")
	else:
		is_open = false
		position.y -= 3.0

func toggle() -> void:
	if is_open:
		close()
	else:
		open()
