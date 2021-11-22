extends GTEntityMover2D
class_name GTForcesEntityMover2D

var forces = []
var acceleration : Vector2

func __integrate_forces(delta):
	for i in forces.size():
		if forces[i][1] > 0.0:
			acceleration += forces[i][0]
			forces[i][1] -= delta
		else:
			forces.remove(i)

func apply_force(force: Vector2, duration: float = 0.0) -> void:
	if not is_enabled:
		return
	acceleration += force
	if duration > 0.0:
		forces.append([force, duration])

func clear_forces():
	forces.clear()
