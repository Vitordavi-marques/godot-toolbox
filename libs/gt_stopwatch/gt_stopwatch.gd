extends Node
class_name GTStopWatch

signal update_time_ellapsed(time)

var time_ellapsed : float = 0.0
var is_playing : bool = false

func _physics_process(delta):
	if is_playing:
		time_ellapsed += delta
		emit_signal("update_time_ellapsed", time_ellapsed)

func start(): is_playing = true
func stop(): is_playing = false

func reset():
	is_playing = false
	time_ellapsed = 0.0
