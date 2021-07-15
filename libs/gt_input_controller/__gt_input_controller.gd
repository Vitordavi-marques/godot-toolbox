extends Node
class_name GTInputController, "res://libs/gt_input_controller/icons/gt_default_controller.svg"

enum { JUST_PRESSED, PRESSED, RELEASED }
const METHODS = [ JUST_PRESSED, PRESSED, RELEASED ]

export (bool) var is_active = true
export (Array, String) var actions

var values = {}

func _ready():
	for action in actions:
		values[action] = { JUST_PRESSED: false, PRESSED: false, RELEASED: false }

func clear_input():
	pass

func poll_input():
	pass

func get_input(action, method):
	pass
