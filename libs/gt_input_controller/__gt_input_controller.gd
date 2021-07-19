extends Node
class_name GTInputController, "res://libs/gt_input_controller/icons/gt_default_controller.svg"

enum { JUST_PRESSED = 0, PRESSED = 1, JUST_RELEASED = 2 }
const METHODS = [ JUST_PRESSED, PRESSED, JUST_RELEASED ]

export (String) var tag = ""
export (bool) var is_active = true
export (Array, String) var actions

var values = {}

func _ready():
	for action in actions:
		values[action] = { JUST_PRESSED: false, PRESSED: false, JUST_RELEASED: false }

# Resets all values for each action and method to false
func clear_input() -> void:
	for action in actions:
		for method in METHODS:
			set_input(action, method, false)

# Returns the value for the given action and method
func get_input(action: String, method: int) -> bool:
	return values[get_action(action)][method]

# Sets the given value for this action and method
func set_input(action: String, method: int, value: bool) -> void:
	values[get_action(action)][method] = value

# Returns the given action plus this input controller's tag as a suffix
func get_action(action: String) -> String:
	if not tag.empty():
		return "%s_%s" % [action, tag]
	return action

# Captures the input state of the controller's actions in the current moment, if enabled
func poll_input() -> void:
	if is_active:
		poll_state()

# Implementation of the method that polls input state
func poll_state() -> void:
	pass
