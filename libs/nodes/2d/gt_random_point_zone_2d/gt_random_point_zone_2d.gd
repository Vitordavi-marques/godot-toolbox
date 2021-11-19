extends Node2D
class_name GTRandomPointZone2D, "res://libs/nodes/icons/arena.svg"

var _shapes = []

func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			assert(child.shape is RectangleShape2D or child.shape is CircleShape2D, "%s (%s) has a child CollisionShape2D with a shape that is not supported (please change it to a RectangleShape2D or CircleShape2D)." % [self.name, self])
			_shapes.append(child)
	assert(_shapes.size() > 0, "%s (%s) has no CollisionShape2D child, please add a CollisionShape2D with either a RectangleShape2D, or a CircleShape2D." % [self.name, self])

# Generates a random point inside a randomly chosen child CollisionShape2D node
func random_point() -> Vector2:
	var rand_index = randi() % _shapes.size()
	var rand_shape = _shapes[rand_index]
	if rand_shape.shape is RectangleShape2D:
		return _random_point_rectangle_shape(rand_shape)
	elif rand_shape.shape is CircleShape2D:
		return _random_point_circle_shape(rand_shape)
	return Vector2.ZERO

func _random_point_rectangle_shape(shape: CollisionShape2D) -> Vector2:
	var size = 2*shape.shape.extents
	
	var rand_pos_x = posmod(randi(),size.x) - (size.x/2) + shape.global_position.x
	var rand_pos_y = posmod(randi(),size.y) - (size.y/2) + shape.global_position.y
	var rand_pos = Vector2(rand_pos_x, rand_pos_y)
	return rand_pos

func _random_point_circle_shape(shape: CollisionShape2D) -> Vector2:
	var radius = shape.shape.radius
	return random_point_circle(shape.x, shape.y, radius)

static func random_point_circle(x, y, radius: int) -> Vector2:
	var rand_r = radius * sqrt(randf())
	var rand_theta = 2*PI * randf()
	
	var rand_pos_x = x + rand_r*cos(rand_theta)
	var rand_pos_y = y + rand_r*sin(rand_theta)
	var rand_pos = Vector2(rand_pos_x, rand_pos_y)
	return rand_pos
