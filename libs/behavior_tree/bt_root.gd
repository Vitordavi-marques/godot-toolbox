extends BehaviorTree
class_name BehaviorTreeRoot, "res://libs/behavior_tree/icons/bt_tree.svg"

const Blackboard = preload("res://libs/behavior_tree/blackboard.gd")

export (bool) var enabled = false
export (NodePath) var actor_path
onready var actor = get_node(actor_path)
onready var blackboard = Blackboard.new()

func _ready():
	if self.get_child_count() != 1:
		print("BehaviorTree Error: root node should have one child!")
		disable()
		return

func _process(delta):
	if not enabled:
		return
	
	blackboard.set("delta", delta)
	
	self.get_child(0).tick(actor, blackboard)

func enable():
	self.enabled = true
	
func disable():
	self.enabled = false
