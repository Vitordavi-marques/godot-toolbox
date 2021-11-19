extends RayCast2D
class_name GTRayCast2D

# Is is generally advised to use a raycast
# only for area collisions or body collisions,
# not both at the same time in the same node.
signal grouped_area_collided(area)
signal grouped_area_collision_info(info)
signal grouped_body_collided(body)
signal grouped_body_collision_info(info)

export (NodePath) var _entity_path # The path of this node's entity
export (NodePath) var _body_path # The path of this node's physical body parent
export (Array, String) var collidable_groups # Groups assigned to collide with this node
export (Array, String) var excluded_groups # Groups assigned to be excluded from colliding with this node
export (bool) var stop_on_first = false # Stop on first object collided, or allow multiple collisions
export (bool) var disable_on_ready = false # Whether or not this area is disabled at _ready

var is_area_colliding : bool = false # Whether or not there is an area currently colliding with this node
var is_body_colliding : bool = false # Whether or not there is a body currently colliding with this node
var collider_areas = [] # Areas that are colliding with this node
var collider_bodies = [] # Bodies that are colliding with this node
var entity : Node # This node's entity
var body : Node2D # This node's physical body parent

func _ready():
	entity = get_node(_entity_path)
	body = get_node(_body_path)
	assert(entity != null, "Error initializing GTRaycast2D, 'entity' property is null")
	assert(body != null, "Error initializing GTRaycast2D, 'body' property is null")
	if disable_on_ready:
		enabled = false

func _physics_process(delta):
	var areas_collide = []
	var bodies_collide = []
	while is_colliding():
		var obj = get_collider()
		if is_node_collidable(obj):
			var info = {
				"collider": obj,
				"collider_shape": get_collider_shape(),
				"collision_normal": get_collision_normal(),
				"collision_point": get_collision_point()}
			if obj is Area2D and collide_with_areas:
				areas_collide.append([obj, info])
				add_exception(obj)
			elif obj is PhysicsBody2D and collide_with_bodies:
				bodies_collide.append([obj, info])
				add_exception(obj)
		force_raycast_update()
	for obj in areas_collide:
		remove_exception(obj[0])
	for obj in bodies_collide:
		remove_exception(obj[0])
	
	is_area_colliding = false
	is_body_colliding = false
	areas_collide.clear()
	bodies_collide.clear()
	for obj in areas_collide:
		is_area_colliding = true
		collider_areas.append(obj[0])
		emit_signal("grouped_area_collided", obj[0])
		emit_signal("grouped_area_collision_info", obj[0], obj[1])
		if stop_on_first: break
	
	for obj in bodies_collide:
		is_body_colliding = true
		collider_bodies.append(obj[0])
		emit_signal("grouped_body_collided", obj[0])
		emit_signal("grouped_body_collision_info", obj[0], obj[1])
		if stop_on_first: break

func is_node_collidable(node: Node) -> bool:
	for group in excluded_groups:
		if node.is_in_group(group):
			return false
	
	if collidable_groups.empty():
		return true
	
	for group in collidable_groups:
		if node.is_in_group(group):
			return true
	return false
