extends GTForcesEntityMover2D
class_name GTTopdownEntityMover2D

export (float) var move_speed = 256
export (float) var max_speed = 256
export (float) var move_acceleration_time = 0.1
export (float) var move_deceleration_time = 0.1

var move_acceleration
var move_deceleration

var move_timer : Timer
var deceleration_timer : Timer
var move_direction : Vector2

func _ready():
	_calculate()
	move_timer = Timer.new()
	move_timer.one_shot = true
	move_timer.name = "_MoveTimer"
	move_timer.connect("timeout", self, "set_move_direction", [Vector2.ZERO])
	add_child(move_timer)
	deceleration_timer = Timer.new()
	deceleration_timer.wait_time = move_deceleration_time
	deceleration_timer.one_shot = true
	deceleration_timer.name = "_DecelerationTimer"
	deceleration_timer.connect("timeout", self, "set_velocity", [Vector2.ZERO])
	add_child(deceleration_timer)

func _physics_process(delta):
	if frozen or not is_enabled:
		return
	if move_direction == Vector2.ZERO and velocity.length() > MOVEMENT_THRESHOLD:
		apply_force(-velocity.normalized() * move_deceleration)
		if deceleration_timer.is_stopped():
			deceleration_timer.start()
	elif move_direction != Vector2.ZERO:
		apply_force(move_direction * move_acceleration)
	else:
		deceleration_timer.stop()
	_integrate_forces(delta)
	velocity += acceleration * delta
	velocity = velocity.clamped(max_speed)
	_move(delta)
	acceleration *= 0

func _integrate_forces(delta):
	for i in forces.size():
		if forces[i][1] > 0.0:
			acceleration += forces[i][0]
			forces[i][1] -= delta
		else:
			forces.remove(i)

func set_move_direction(_dir: Vector2, duration: float = 0.0) -> void:
	move_direction = _dir
	if duration > 0.0:
		move_timer.wait_time = duration
		move_timer.start()

# Setters
func set_move_speed(_value):
	move_speed = _value
	_calculate()

func set_move_acceleration_time(_value):
	move_acceleration_time = _value
	_calculate()

func set_move_deceleration_time(_value):
	move_deceleration_time = _value
	deceleration_timer.wait_time = move_deceleration_time
	_calculate()

func _calculate():
	move_acceleration = move_speed / move_acceleration_time
	move_deceleration = move_speed / move_deceleration_time
