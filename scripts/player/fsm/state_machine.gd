class_name StateMachine
extends Node

## Generic State Machine that manages State nodes as children.
## It passes process, physics_process, and input calls to the active state.

## Emitted when transitioning to a new state.
signal transitioned(state_name: String)

## Path to the initial state node.
@export var initial_state: State

## The currently active state.
@onready var state: State = initial_state

func _ready() -> void:
	await owner.ready
	# Initialize all child states with a reference to this state machine.
	for child in get_children():
		if child is State:
			child.state_machine = self
	
	if state:
		state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

## Transitions the state machine to a new state.
## [param target_state_name] The name of the child node to transition to.
## [param msg] An optional dictionary to pass data to the new state's enter() method.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		push_error("StateMachine: State '%s' not found." % target_state_name)
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", target_state_name)
