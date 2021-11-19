extends GTForcesEntityMover2D
class_name GTSidescrollerEntityMover2D

signal jumped()
signal landed()
signal ran_out_of_jumps()

export (int) var move_speed = 256
export (int) var max_move_speed = 256
export (float) var move_acceleration_time = 0.1
export (float) var move_deceleration_time = 0.1
export (float) var air_acceleration_time = 0.1
export (float) var air_deceleration_time = 0.1
export (Vector2) var ground_snap = Vector2.DOWN * 8

export (int) var jump_height = 128
export (float) var jump_time = 0.3
export (float) var hang_time = 0.016
export (float) var fall_time = 0.3
export (float) var jump_damp = 1.0
export (int) var max_jumps = 1
export (bool) var restore_jumps_on_land = true
export (Vector2) var gravity_mask = Vector2.DOWN

onready var move_acceleration = max_move_speed / move_acceleration_time
onready var move_deceleration = max_move_speed / move_deceleration_time
onready var air_acceleration = max_move_speed / air_acceleration_time
onready var air_deceleration = max_move_speed / air_deceleration_time

onready var jump_speed = Utils.jump_speed_formula(jump_height, jump_time)
onready var jump_gravity = Utils.gravity_formula(jump_height, jump_time)
onready var fall_gravity = Utils.gravity_formula(jump_height, fall_time)
onready var available_jumps : int = max_jumps

var move_direction : int = 0
var is_falling : bool = false
var hang_timer : Timer

func _ready():
	hang_timer = Timer.new()
	hang_timer.wait_time = hang_time
	hang_timer.one_shot = true
	hang_timer.name = "_HangTimer"
	add_child(hang_timer)

func _physics_process(delta):
	if frozen or not is_enabled:
		return
	_apply_gravity()
	_apply_movement()
	._move(delta)

func _apply_gravity():
	if velocity.y < 0:
		apply_force(gravity_mask * jump_gravity)
	else:
		if not is_falling:
			is_falling = true
			hang_timer.start()
			velocity.y = 0
		elif hang_timer.is_stopped():
			apply_force(gravity_mask * fall_gravity)

func _apply_movement():
	var acc = move_acceleration
	var dec = move_deceleration
	if abs(velocity.y) > MOVEMENT_THRESHOLD:
		acc = air_acceleration
		dec = air_deceleration
	if move_direction == 0 and abs(velocity.x) > MOVEMENT_THRESHOLD:
		apply_force(-sign(velocity.x) * Vector2.RIGHT * dec)
	else:
		apply_force(move_direction * Vector2.RIGHT * acc)
	velocity.x = clamp(velocity.x, -max_move_speed, max_move_speed)
	if velocity.length() < MOVEMENT_THRESHOLD:
		velocity = Vector2.ZERO

# Jump, applying upward speed
func jump() -> void:
	if is_enabled and can_jump():
		_turn_off_snap()
		decrease_jump()
		is_falling = false
		velocity.y = jump_speed
		emit_signal("jumped")

# Call to land on ground correctly
func land():
	if is_enabled:
		_turn_on_snap()
		restore_jumps()
		is_falling = false
		emit_signal("landed")

func decrease_jump() -> void:
	available_jumps = clamp(available_jumps-1, 0, max_jumps)
	if available_jumps == 0:
		emit_signal("ran_out_of_jumps")

func set_move_direction(dir: int) -> void: move_direction = dir

func restore_jumps() -> void: available_jumps = max_jumps
func can_jump() -> bool: return available_jumps > 0
func damp_jump() -> void: velocity.y *= jump_damp

func _turn_on_snap() -> void: snap = ground_snap
func _turn_off_snap() -> void: snap = Vector2.ZERO
