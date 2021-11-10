extends GTInputController
class_name GTDeviceController

func poll_input():
	for action in _actions.keys():
		for method in METHODS.keys():
			if method == JUST_PRESSED:
				set_input(action, method, Input.is_action_just_pressed(action))
			elif method == PRESSED:
				set_input(action, method, Input.is_action_pressed(action))
			elif method == JUST_RELEASED:
				set_input(action, method, Input.is_action_just_released(action))
