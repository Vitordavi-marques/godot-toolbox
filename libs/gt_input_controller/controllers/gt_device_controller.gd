extends GTInputController
class_name GTDeviceController, "res://libs/gt_input_controller/icons/gt_device_controller.svg"

func clear_input():
	for action in actions:
		for method in METHODS:
			values[action][method] = false

func poll_input():
	for action in actions:
		for method in METHODS:
			if method == JUST_PRESSED:
				values[action][method] = Input.is_action_just_pressed(action)
			elif method == PRESSED:
				values[action][method] = Input.is_action_pressed(action)
			elif method == RELEASED:
				values[action][method] = Input.is_action_just_released(action)

func get_input(action, method):
	return values[action][method]
