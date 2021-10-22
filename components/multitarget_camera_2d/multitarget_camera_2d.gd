extends Camera2D

export (float) var move_speed = 0.5
export (float) var zoom_speed = 0.25
export (float) var min_zoom = 0.75
export (float) var max_zoom = 2
export (bool) var allow_zoom = true
export var padding = Vector2(100, 100) # Padding around bounding box of targets

onready var _screen_size = get_viewport_rect().size # Size of the viewport

var _targets = [] # Array of targets and weights for the camera to follow
var _weight_total : int = 0 # Total weight calculated for each target

func _process(delta):
	if !_targets:
		return
	
	var p = Vector2.ZERO
	for target in _targets:
		var target_pos = target[0].global_position
		var target_weight = target[1]
		p += target_pos * target_weight
	p /= _weight_total
	global_position = lerp(global_position, p, move_speed)

	var r = Rect2(global_position, Vector2.ONE)
	for target in _targets:
		var target_pos = target[0].global_position
		r = r.expand(target_pos)
	r = r.grow_individual(padding.x, padding.y, padding.x, padding.y)
	
	if allow_zoom:
		var d = max(r.size.x, r.size.y)
		var z
		if r.size.x > r.size.y * _screen_size.aspect():
			z = clamp(r.size.x / _screen_size.x, min_zoom, max_zoom)
		else:
			z = clamp(r.size.y / _screen_size.y, min_zoom, max_zoom)
		zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)

# Adds a target node for the camera to follow
func add_target(t):
	add_weighted_target(t, 1)

# Adds a target node with weight for the camera to follow
func add_weighted_target(t, w):
	if not t in _targets:
		_targets.append([t, w])
	_weight_total += w

# Removes a target node from the target list
func remove_target(t):
	for i in _targets.size():
		if _targets[i][0] == t:
			_weight_total -= _targets[i][1]
			_targets.remove(i)

# Removes all targets
func clear_targets():
	for t in _targets:
		remove_target(t)
