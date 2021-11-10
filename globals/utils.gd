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

func snap_direction_4(dir: Vector2) -> Vector2:
	var angle = (PI/4)*(int(dir.angle()/(PI/4)))
	return Vector2(sin(angle), cos(angle))

func get_screen_size() -> Vector2:
	return get_viewport().get_visible_rect().size

func get_screen_center() -> Vector2:
	return get_screen_size() / 2

func rand_sign() -> int:
	return int(pow(-1,randi()%2))

func component_assert_message(component) -> String:
	return "Error initializing Component '%s' (%s)" % [component.name, component]
