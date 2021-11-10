extends GTSteeringBehavior2D
class_name GTSteeringBehaviorAbsoluteSeek2D

var steering : Vector2

func move(delta):
	if not is_enabled:
		return
	var target = actor.get_target_pos()
	var desired_velocity = (target-actor.body.global_position).normalized() * actor.max_speed
	actor.velocity = desired_velocity.clamped(actor.max_speed)
