extends BehaviorTreeDecorator
class_name BehaviorTreeInverter, "res://libs/behavior_tree/icons/bt_inverter.svg"

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		
		if response == SUCCESS:
			return FAILURE
		elif response == FAILURE:
			return SUCCESS
		
		return RUNNING
