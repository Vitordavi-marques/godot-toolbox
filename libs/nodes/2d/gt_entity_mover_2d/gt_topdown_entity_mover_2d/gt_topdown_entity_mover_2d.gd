extends GTEntityMover2D
class_name GTTopdownEntityMover2D

const CURVE_LINEAR_EASE_IN = preload("res://libs/resources/curves/gt_linear_ease_in_curve.tres")
const CURVE_LINEAR_EASE_OUT = preload("res://libs/resources/curves/gt_linear_ease_out_curve.tres")

export (int) var move_speed = 256
export (Curve) var velocity_curve = CURVE_LINEAR_EASE_IN
export (float) var acceleration_time = 0.1
export (Curve) var friction_curve = CURVE_LINEAR_EASE_OUT
export (float) var deceleration_time = 0.1

var move_direction : Vector2 = Vector2.ZERO
var move_direction_press_timer : float = 0.0

func _movement(delta):
	if frozen or not is_enabled:
		return
	move_direction_press_timer += delta
	
	# Movement
	var info = get_acceleration_info()
	var dir = move_direction.normalized()
	if move_direction == Vector2.ZERO:
		info = get_deceleration_info()
		dir = velocity.normalized()
	var t = clamp(move_direction_press_timer/info["time"], 0.0, 1.0)
	var desired_velocity = move_speed * info["curve"].interpolate_baked(t)
	
	velocity = dir * desired_velocity
	if velocity.length() < MOVEMENT_THRESHOLD:
		velocity = Vector2.ZERO
	._move(delta)

func get_acceleration_info() -> Dictionary:
	var info = {}
	info["curve"] = velocity_curve
	info["time"] = acceleration_time
	return info

func get_deceleration_info() -> Dictionary:
	var info = {}
	info["curve"] = friction_curve
	info["time"] = deceleration_time
	return info

func set_move_direction(dir: Vector2) -> void:
	if dir != move_direction:
		move_direction_press_timer = 0.0
	move_direction = dir

func set_move_speed(_speed: int) -> void:
	move_speed = _speed
