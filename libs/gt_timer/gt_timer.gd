extends Timer
class_name GTTimer

signal time_left_updated(time_left)

func _physics_process(delta):
	if not is_stopped():
		emit_signal("time_left_updated", time_left)
