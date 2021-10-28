extends GTDeviceController

signal updated_move_direction(direction)

export (bool) var normalize_direction = true # Normalize move direction or not

var move_direction : Vector2

func _physics_process(delta):
	move_direction = Vector2.ZERO
	move_direction.x = int(get_input("act_move_right", PRESSED))-int(get_input("act_move_left", PRESSED))
	move_direction.y = int(get_input("act_move_down", PRESSED))-int(get_input("act_move_up", PRESSED))
	if normalize_direction: move_direction = move_direction.normalized()
	emit_signal("updated_move_direction", move_direction)
