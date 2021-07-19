extends Node
class_name GTInputController, "res://libs/gt_input_controller/icons/gt_default_controller.svg"

enum { JUST_PRESSED = 0, PRESSED = 1, JUST_RELEASED = 2 }
const METHODS = {
	JUST_PRESSED : "just_pressed",
	PRESSED : "pressed",
	JUST_RELEASED : "just_released"}

export (String) var tag = ""
export (bool) var is_active = true
var actions = {}

var values = {}

func _ready():
	for child in get_children():
		if child is GTInputAction:
			actions[child.action] = child
	for action in actions.keys():
		values[action] = { JUST_PRESSED: false, PRESSED: false, JUST_RELEASED: false }

# Sets all values for each action and method to false
func clear_input():
	for action in actions.keys():
		for method in METHODS.keys():
			set_input(action, method, false)

# Returns the value for the given action and method
func get_input(action: String, method: int):
	return values[get_action(action)][method]

# Sets the given value for this action and method
func set_input(action: String, method: int, value):
	if value:
		actions[action].emit_signal(METHODS[method])
	values[get_action(action)][method] = value

# Returns the given action plus this input controller's tag as a suffix
func get_action(action: String):
	if not tag.empty():
		return "%s_%s" % [action, tag]
	return action

# Captures the input state of the controller's actions in the current moment
func poll_input():
	if is_active:
		poll_state()

# Implementation of the method that polls input state.
func poll_state():
	pass
