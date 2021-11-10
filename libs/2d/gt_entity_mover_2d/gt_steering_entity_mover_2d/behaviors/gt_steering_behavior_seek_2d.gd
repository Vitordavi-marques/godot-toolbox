extends GTSteeringBehavior2D
class_name GTSteeringBehaviorSeek2D

export (int) var max_force = 64
export (bool) var use_target_node = true

var _target : Node2D = null
var _target_pos : Vector2 = Vector2.ZERO
var steering : Vector2

func move(delta):
	if not is_enabled:
		return
	var target = _get_target_pos()
	var desired_velocity = (target-actor.body.global_position).normalized() * actor.max_speed
	steering = desired_velocity - actor.velocity
	steering.clamped(max_force)
	steering /= actor.mass
	actor.velocity += steering*delta

func _get_target_pos() -> Vector2:
	if use_target_node and _target:
		return _target.global_position
	return _target_pos

func set_target(t: Node2D):
	_target = t

func set_target_pos(_pos : Vector2):
	_target_pos = _pos
