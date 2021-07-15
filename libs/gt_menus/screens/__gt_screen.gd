extends Control
class_name GTScreen

var transition

func _ready():
	for child in get_children():
		if child is GTScreenTransition:
			transition = child
	assert(transition != null, "%s has no set Transition" % self.name)
	visible = false

func enter():
	transition.enter()

func exit():
	transition.exit()
