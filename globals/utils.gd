extends Node

func get_timer_formatted(timer: float) -> String:
	var time = int(timer)
	var seconds = int(time % 60)
	var minutes = int(time / 60)
	var result
	
	if minutes > 0:
		result = "%s:%s" % [minutes, str(seconds).pad_zeros(2)]
	else:
		result = str(seconds).pad_zeros(2)
	return result

func gravity_formula(height, time):
	return 2*height/(time*time)

func jump_speed_formula(height, time):
	return -2*height/time

func rand_direction() -> Vector2:
	var rand_angle = randf()*2*PI
	return Vector2(cos(rand_angle), sin(rand_angle))
