class_name State
extends Node

## Virtual base class for all states in the StateMachine.
## Every state should inherit from this and override its methods.

## Reference to the StateMachine node.
var state_machine: StateMachine = null

## Called when the state machine enters this state.
func enter(_msg := {}) -> void:
	pass

## Called when the state machine exits this state.
func exit() -> void:
	pass

## Corresponds to _process().
func update(_delta: float) -> void:
	pass

## Corresponds to _physics_process().
func physics_update(_delta: float) -> void:
	pass

## Corresponds to _unhandled_input().
func handle_input(_event: InputEvent) -> void:
	pass
