class_name AIState
extends Node

## Virtual base class for all AI states in the Funbot FSM.

var state_machine: AIStateMachine = null

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
