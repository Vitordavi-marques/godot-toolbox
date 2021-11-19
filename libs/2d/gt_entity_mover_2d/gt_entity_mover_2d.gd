extends Node
class_name GTEntityMover2D, "res://libs/icons/move.svg"

signal updated_position(new_position)
signal has_collided()
signal collided(result)

const MOVEMENT_THRESHOLD = 4 # Minimum length for the entity to be considered moving. Values below this get clamped to 0
enum MOVEMENT_MODE {
	MOVE_AND_COLLIDE = 1,
	MOVE_AND_SLIDE = 2,
	MOVE_AND_SLIDE_WITH_SNAP = 3}

export (NodePath) var body_path # The body that will be moved
export (MOVEMENT_MODE) var movement_mode = MOVEMENT_MODE.MOVE_AND_COLLIDE # Movement mode
export (Vector2) var floor_normal = Vector2.UP # Floor normal used in sidescroller games
export (Vector2) var movement_mask = Vector2(1,1) # Movement mask

export (bool) var frozen = false # Whether or not the body is currently frozen
export (bool) var is_enabled = true # Whether or not this node is enabled
export (bool) var debug_mode = false

var snap : Vector2
var _stop_on_slope : bool = false
var _max_slides : int = 4
var _floor_max_angle : float = 0.785398
var _infinite_inertia : bool = true

var body : KinematicBody2D
var velocity : Vector2

func _ready():
	body = get_node(body_path)
	assert(body, "Error initializing GTEntityMover2D: 'body' property is null")

func _physics_process(delta):
	if frozen or not is_enabled:
		return
	_move(delta)

func _move(delta):
	match movement_mode:
		MOVEMENT_MODE.MOVE_AND_COLLIDE:
			_move_and_collide(delta)
		MOVEMENT_MODE.MOVE_AND_SLIDE:
			_move_and_slide(delta)
		MOVEMENT_MODE.MOVE_AND_SLIDE_WITH_SNAP:
			_move_and_slide_with_snap(delta)
	if velocity.length() < MOVEMENT_THRESHOLD:
		velocity = Vector2.ZERO
	if debug_mode:
		print("velocity: %s" % [velocity])
	emit_signal("updated_position", body.global_position)

func _move_and_collide(delta):
	var collision = body.move_and_collide(velocity * movement_mask * delta)
	if collision:
		_on_collision(body, collision)
		emit_signal("has_collided")
		emit_signal("collided", collision)

func _move_and_slide(delta):
	velocity = body.move_and_slide(velocity * movement_mask, floor_normal, _stop_on_slope, _max_slides, _floor_max_angle, _infinite_inertia)
	if body.get_slide_count() > 0:
		_on_collision(body)

func _move_and_slide_with_snap(delta):
	velocity = body.move_and_slide_with_snap(velocity * movement_mask, snap, floor_normal, _stop_on_slope, _max_slides, _floor_max_angle, _infinite_inertia)
	if body.get_slide_count() > 0:
		_on_collision(body)

# Can be overriden for custom collision resolution
func _on_collision(_body, collision = null):
	pass

# Freezes the body, preserving momentum or not
func freeze(preserve_momentum: bool = true) -> void:
	if not preserve_momentum:
		velocity = Vector2.ZERO
	frozen = true

# Unfreezes the body, allowing it to move again
func unfreeze() -> void:
	frozen = false

func enable() -> void: is_enabled = true
func disable() -> void: is_enabled = false
func set_movement_mask(mask: Vector2) -> void: movement_mask = mask
func set_velocity(_velocity: Vector2) -> void: velocity = _velocity
func set_snap(_snap: Vector2): snap = _snap

func set_movement_parameters(p_stop_on_slope: bool = false, p_max_slides: int = 4, p_floor_max_angle: float = 0.785398, p_infinite_inertia: bool = true):
	_stop_on_slope = p_stop_on_slope
	_max_slides = p_max_slides
	_floor_max_angle = p_floor_max_angle
	_infinite_inertia = p_infinite_inertia
