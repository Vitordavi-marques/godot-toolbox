extends GTEntityMover2D
class_name GTForcesEntityMover2D

var forces = []
var acceleration : Vector2

func apply_force(force: Vector2, duration: float = 0.0) -> void:
	if not is_enabled:
		return
	acceleration += force
	if duration > 0.0:
		forces.append([force, duration])

func clear_forces():
	forces.clear()
