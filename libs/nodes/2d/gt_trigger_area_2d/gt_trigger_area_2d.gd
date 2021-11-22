extends Area2D
class_name GTTriggerArea2D

signal effect()

enum TRIGGER_TYPE { ENTER = 0, INSIDE = 1, EXIT = 2 }
export (TRIGGER_TYPE) var trigger_type = TRIGGER_TYPE.ENTER # The type of this trigger
export (bool) var one_shot = false # Whether this node triggers only once, or not

func _ready():
	connect("area_entered", self, "__on_area_entered")
	connect("area_exited", self, "__on_area_exited")
	connect("body_entered", self, "__on_body_entered")
	connect("body_exited", self, "__on_body_exited")

func _physics_process(delta):
	if trigger_type == TRIGGER_TYPE.INSIDE:
		if get_overlapping_areas().size() > 0 or get_overlapping_bodies().size() > 0:
			_emit_effect()

func __on_area_entered(_area: Area2D) -> void:
	if trigger_type == TRIGGER_TYPE.ENTER:
		_emit_effect()

func __on_area_exited(_area: Area2D) -> void:
	if trigger_type == TRIGGER_TYPE.EXIT:
		_emit_effect()

func __on_body_entered(_body: Node) -> void:
	if trigger_type == TRIGGER_TYPE.ENTER:
		_emit_effect()

func __on_body_exited(_body: Node) -> void:
	if trigger_type == TRIGGER_TYPE.EXIT:
		_emit_effect()

func _check_one_shot() -> void:
	if one_shot:
		disable_all_shapes()

func _emit_effect() -> void:
	_check_one_shot()
	emit_signal("effect")

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
