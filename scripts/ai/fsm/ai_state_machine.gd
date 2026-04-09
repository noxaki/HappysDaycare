class_name AIStateMachine
extends Node

## Manages AI State nodes for the Funbot.

signal transitioned(state_name: String)

@export var initial_state: AIState

@onready var state: AIState = initial_state

func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is AIState:
			child.state_machine = self
	
	if state:
		state.enter()

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		push_error("AIStateMachine: State '%s' not found." % target_state_name)
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", target_state_name)
