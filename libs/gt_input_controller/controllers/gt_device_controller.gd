extends GTInputController
class_name GTDeviceController, "res://libs/gt_input_controller/icons/gt_device_controller.svg"

func poll_input():
	for action in actions:
		for method in METHODS:
			if method == JUST_PRESSED:
				set_input(action, method, Input.is_action_just_pressed(action))
			elif method == PRESSED:
				set_input(action, method, Input.is_action_pressed(action))
			elif method == RELEASED:
				set_input(action, method, Input.is_action_just_released(action))
