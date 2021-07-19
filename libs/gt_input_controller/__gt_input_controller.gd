extends Node
class_name GTInputController, "res://libs/gt_input_controller/icons/gt_default_controller.svg"

enum { JUST_PRESSED, PRESSED, RELEASED }
const METHODS = [ JUST_PRESSED, PRESSED, RELEASED ]

export (String) var tag = ""
export (bool) var is_active = true
var actions = []

var values = {}

func _ready():
	for child in get_children():
		if child is GTInputAction:
			actions.append(child.action)
	for action in actions:
		values[action] = { JUST_PRESSED: false, PRESSED: false, RELEASED: false }

# Sets all values for each action and method to false
func clear_input():
	for action in actions:
		for method in METHODS:
			set_input(action, method, false)

# Returns the value for the given action and method
func get_input(action: String, method: int):
	return values[get_action(action)][method]

# Sets the given value for this action and method
func set_input(action: String, method: int, value):
	values[get_action(action)][method] = value

# Returns the given action plus this input controller's tag as a suffix
func get_action(action: String):
	if not tag.empty():
		return "%s_%s" % [action, tag]
	return action

# Captures the input state of the controller's actions in the current moment
func poll_input():
	pass
