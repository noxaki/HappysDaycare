class_name PlayerController
extends CharacterBody3D

## Central controller for the first-person player.
## Manages movement variables, mouse look, and node references.

@export_group("Movement Settings")
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var acceleration: float = 10.0
@export var friction: float = 12.0

@export_group("Look Settings")
@export var mouse_sensitivity: float = 0.002
@export var head_y_limit: float = 89.0

## Node References
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var state_machine: StateMachine = $StateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Mouse look logic
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-head_y_limit), deg_to_rad(head_y_limit))
	
	# Release mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_move_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func apply_velocity() -> void:
	move_and_slide()
