extends Camera2D
class_name GTMultitargetCamera2D

export (float) var move_speed = 0.5
export (float) var zoom_speed = 0.25
export (float) var min_zoom = 0.75
export (float) var max_zoom = 2
export (bool) var allow_zoom = true
export var margin = Vector2(100, 100)

onready var screen_size = get_viewport_rect().size

var targets = []

func _process(delta):
	if !targets:
		return
	
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)

	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	if allow_zoom:
		var d = max(r.size.x, r.size.y)
		var z
		if r.size.x > r.size.y * screen_size.aspect():
			z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
		else:
			z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
		zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)


func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.remove(targets.find(t))
