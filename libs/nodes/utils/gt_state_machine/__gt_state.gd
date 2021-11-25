extends Node
class_name GTState

signal state_entered()
signal state_exited()
signal finished

var fsm : Node # This state's GTStateMachine node
var entity : Node # The state machine's entity

# Callback for when this state becomes the state machine's current state
func enter(info: Dictionary = {}) -> void:
	pass

# Callback for when this state is substituted by another current state
func exit() -> void:
	pass

# Overridable input callback
func input(event: InputEvent) -> void:
	pass

# Overridable process callback
func process(_delta: float) -> void:
	pass

# Overridable physics_process callback
func physics_process(_delta: float) -> void:
	pass
