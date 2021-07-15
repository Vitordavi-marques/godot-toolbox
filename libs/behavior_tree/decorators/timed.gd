extends BehaviorTreeDecorator
class_name BehaviorTreeTimed, "res://libs/behavior_tree/icons/bt_category_decorator.svg"

export (float) var period = 1.0
onready var time : float = 0.0

func tick(actor, blackboard):
	var delta = blackboard.get("delta")
	time -= delta
	if time <= 0.0:
		reset_time()
		for c in get_children():
			return c.tick(actor, blackboard)
	return SUCCESS

func reset_time():
	time = period
