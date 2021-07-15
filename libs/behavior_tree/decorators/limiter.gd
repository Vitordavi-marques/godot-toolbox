extends BehaviorTreeDecorator
class_name BehaviorTreeLimiter, "res://libs/behavior_tree/icons/bt_limiter.svg"

export (int) var max_count = 0
onready var cache_key = "limiter_%s" % self.get_instance_id()

func tick(actor, blackboard):
	var current_count = blackboard.get(cache_key)
	
	if current_count == null:
		current_count = 0
	
	if current_count <= max_count:
		blackboard.set(cache_key, current_count + 1)
		return self.get_child(0).tick(actor, blackboard)
	else:
		return FAILURE
