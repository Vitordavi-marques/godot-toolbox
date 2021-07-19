extends Area2D
class_name GTRandomPointArea2D

var shapes = []

func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			assert(child.shape is RectangleShape2D or child.shape is CircleShape2D, "%s (%s) has a CollisionShape2D with a shape that is not supported (please add a RectangleShape2D or CircleShape2D)" % [self.name, self])
			shapes.append(child)
	assert(shapes.size() > 0, "%s (%s) has no CollisionShape2D" % [self.name, self])
	randomize()

func random_point() -> Vector2:
	var rand_index = randi() % shapes.size()
	var rand_shape = shapes[rand_index]
	if rand_shape.shape is RectangleShape2D:
		return random_point_rectangle(rand_shape)
	elif rand_shape.shape is CircleShape2D:
		return random_point_circle(rand_shape)
	return Vector2.ZERO

func random_point_rectangle(rand_shape: CollisionShape2D) -> Vector2:
	var size = 2*rand_shape.shape.extents
	
	var rand_pos_x = posmod(randi(),size.x) - (size.x/2) + rand_shape.global_position.x
	var rand_pos_y = posmod(randi(),size.y) - (size.y/2) + rand_shape.global_position.y
	var rand_pos = Vector2(rand_pos_x, rand_pos_y)
	return rand_pos

func random_point_circle(rand_shape: CollisionShape2D) -> Vector2:
	var radius = rand_shape.shape.radius
	var rand_r = radius * sqrt(randf())
	var rand_theta = 2*PI * randf()
	
	var rand_pos_x = rand_shape.x + rand_r*cos(rand_theta)
	var rand_pos_y = rand_shape.y + rand_r*sin(rand_theta)
	var rand_pos = Vector2(rand_pos_x, rand_pos_y)
	return rand_pos
