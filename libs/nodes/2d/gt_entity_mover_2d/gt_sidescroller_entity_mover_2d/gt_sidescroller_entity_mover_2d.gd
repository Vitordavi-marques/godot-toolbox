extends GTEntityMover2D
class_name GTSidescrollerEntityMover2D

const CURVE_LINEAR_EASE_IN = preload("res://libs/resources/curves/gt_linear_ease_in_curve.tres")
const CURVE_LINEAR_EASE_OUT = preload("res://libs/resources/curves/gt_linear_ease_out_curve.tres")

signal jumped()
signal landed()
signal ran_out_of_jumps()

export (int) var move_speed = 256
export (Curve) var ground_velocity_curve = CURVE_LINEAR_EASE_IN
export (float) var ground_acceleration_time = 0.1
export (Curve) var ground_friction_curve = CURVE_LINEAR_EASE_OUT
export (float) var ground_deceleration_time = 0.1
export (Curve) var air_velocity_curve = CURVE_LINEAR_EASE_IN
export (float) var air_acceleration_time = 0.1
export (Curve) var air_friction_curve = CURVE_LINEAR_EASE_OUT
export (float) var air_deceleration_time = 0.1
export (Vector2) var ground_snap = Vector2.DOWN * 8

export (int) var jump_height = 128
export (float) var jump_time = 0.3
export (float) var fall_time = 0.3
export (float) var jump_damp = 1.0
export (int) var max_jumps = 1
export (bool) var restore_jumps_on_land = true
export (Vector2) var gravity_mask = Vector2.DOWN

onready var jump_speed = jump_speed_formula(jump_height, jump_time)
onready var jump_gravity = gravity_formula(jump_height, jump_time)
onready var fall_gravity = gravity_formula(jump_height, fall_time)
onready var available_jumps : int = max_jumps

var move_direction : int = 0
var move_direction_press_timer : float = 0.0

func _movement(delta):
	if frozen or not is_enabled:
		return
	move_direction_press_timer += delta
	
	# Gravity
	if velocity.y < 0:
		velocity.y += jump_gravity * delta
	else:
		velocity.y += fall_gravity * delta
	
	# Movement
	var info
	var move_sign
	if move_direction != 0:
		info = get_acceleration_info()
		move_sign = sign(move_direction)
	else:
		info = get_deceleration_info()
		move_sign = sign(velocity.x)
	var t = clamp(move_direction_press_timer/info["time"], 0.0, 1.0)
	var desired_velocity = move_speed * info["curve"].interpolate_baked(t)
	
	velocity.x = move_sign * desired_velocity
	if velocity.length() < MOVEMENT_THRESHOLD:
		velocity = Vector2.ZERO
	._move(delta)

# Jump, applying upward speed
func jump() -> void:
	if is_enabled and can_jump():
		_turn_off_snap()
		decrease_jump()
		velocity.y = jump_speed
		emit_signal("jumped")

# Call to land on ground correctly
func land():
	if is_enabled:
		_turn_on_snap()
		restore_jumps()
		emit_signal("landed")

func get_acceleration_info() -> Dictionary:
	var info = {}
	if body.is_on_floor():
		info["curve"] = ground_velocity_curve
		info["time"] = ground_acceleration_time
	else:
		info["curve"] = air_velocity_curve
		info["time"] = air_acceleration_time
	return info

func get_deceleration_info() -> Dictionary:
	var info = {}
	if body.is_on_floor():
		info["curve"] = ground_friction_curve
		info["time"] = ground_deceleration_time
	else:
		info["curve"] = air_friction_curve
		info["time"] = air_deceleration_time
	return info

func decrease_jump() -> void:
	available_jumps = clamp(available_jumps-1, 0, max_jumps)
	if available_jumps == 0:
		emit_signal("ran_out_of_jumps")

func set_move_direction(dir: int) -> void:
	if dir != move_direction:
		move_direction_press_timer = 0.0
	move_direction = dir

func restore_jumps() -> void: available_jumps = max_jumps
func can_jump() -> bool: return available_jumps > 0
func damp_jump() -> void: velocity.y *= jump_damp

func _turn_on_snap() -> void: snap = ground_snap
func _turn_off_snap() -> void: snap = Vector2.ZERO

func gravity_formula(height, time):
	return (2*height)/(time*time)

func jump_speed_formula(height, time):
	return -(2*height)/time
