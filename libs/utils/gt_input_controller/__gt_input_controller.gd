extends Node
class_name GTInputController, "res://libs/icons/gamepad-white.svg"

enum { JUST_PRESSED = 0, PRESSED = 1, JUST_RELEASED = 2 }
const METHODS = {
	JUST_PRESSED : "just_pressed",
	PRESSED : "pressed",
	JUST_RELEASED : "just_released"}

export (String) var tag = "" # Suffix used in string concatenation for each input action available
export (bool) var is_enabled = true # Whether this node is enabled or not
var _actions = {}
var _values = {}

func _ready():
	for child in get_children():
		if child is GTInputAction:
			_actions[child.action] = child
	for action in _actions.keys():
		_values[action] = { JUST_PRESSED: false, PRESSED: false, JUST_RELEASED: false }

func _process(delta):
	if is_enabled:
		poll_input()

# Sets all values for each action and method to false
func clear_input() -> void:
	for action in _actions.keys():
		for method in METHODS.keys():
			set_input(action, method, false)

# Returns the value for the given action and method
func get_input(action: String, method: int):
	return _values[_get_action(action)][method]

# Sets the given value for this action and method
func set_input(action: String, method: int, value) -> void:
	if value:
		_actions[action].emit_signal(METHODS[method])
	_values[_get_action(action)][method] = value

# Returns the given action plus this input controller's tag as a suffix
func _get_action(action: String):
	if not tag.empty():
		return "%s_%s" % [action, tag]
	return action

# Implementation of the method that polls input state.
func poll_input() -> void:
	pass

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true
