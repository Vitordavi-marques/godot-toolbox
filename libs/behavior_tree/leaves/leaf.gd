extends BehaviorTreeNode
class_name BehaviorTreeLeaf, "res://libs/behavior_tree/icons/bt_action.svg"

func _ready():
	if self.get_child_count() != 0:
		print("BehaviorTree Error: Leaf %s should not have children" % self.name)
