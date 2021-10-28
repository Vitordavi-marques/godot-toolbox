extends Area2D
class_name GTGroupedArea2D

signal grouped_area_entered(area)
signal grouped_area_exited(area)
signal grouped_body_entered(body)
signal grouped_body_exited(body)

export (NodePath) var _body_path # The path of this node's physical body parent
export (Array, String) var collidable_groups # Groups assigned to collide with this node
export (Array, String) var excluded_groups # Groups assigned to be excluded from colliding with this node
export (bool) var disable_on_ready = false # Whether or not this area is disabled at _ready

var is_area_colliding : bool = false # Whether or not there is an area currently colliding with this node
var is_body_colliding : bool = false # Whether or not there is a body currently colliding with this node
var collider_area : Node2D # Area that is colliding with this node
var collider_body : Node2D # Body that is colliding with this node
var body : Node2D # This node's physical body parent

func _ready():
	body = get_node(_body_path)
	assert(body != null, "Error initializing GTArea2D, 'body' property is null")
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	if disable_on_ready:
		disable_all_shapes()

# If a certain node can collide with this area
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

func _on_area_entered(area: Area2D) -> void:
	if is_node_collidable(area):
		is_area_colliding = true
		collider_area = area
		emit_signal("grouped_area_entered", area)

func _on_area_exited(area: Area2D) -> void:
	if is_node_collidable(area):
		is_area_colliding = false
		collider_area = null
		emit_signal("grouped_area_exited", area)

func _on_body_entered(_body: Node) -> void:
	if is_node_collidable(_body):
		is_body_colliding = true
		collider_body = _body
		emit_signal("grouped_body_entered", _body)

func _on_body_exited(_body: Node) -> void:
	if is_node_collidable(_body):
		is_body_colliding = false
		collider_body = null
		emit_signal("grouped_body_exited", _body)

# Enable all CollisionShape2D children nodes
func enable_all_shapes() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)

# Disable all CollisionShape2D children nodes
func disable_all_shapes() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
