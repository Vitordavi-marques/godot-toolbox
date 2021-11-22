extends GTEntityMover2D
class_name GTSteeringEntityMover2D

export (int) var max_speed = 128
export (float) var mass = 1.0

var behaviors = []

func _ready():
	for child in get_children():
		if child is GTSteeringBehavior2D:
			behaviors.append(child)

func _movement(delta):
	if frozen or not is_enabled:
		return
	for behavior in behaviors:
		behavior.move(delta)
	velocity = velocity.clamped(max_speed)
	._move(delta)
