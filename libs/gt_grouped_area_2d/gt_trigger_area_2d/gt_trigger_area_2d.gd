extends GTGroupedArea2D
class_name GTTriggerArea2D

signal effect()

enum TRIGGER_TYPE { ENTER = 0, INSIDE = 1, EXIT = 2 }
export (TRIGGER_TYPE) var trigger_type = TRIGGER_TYPE.ENTER # The type of this trigger
export (bool) var one_shot = false # Whether this node triggers only once, or not

func _ready():
	connect("grouped_area_entered", self, "_on_grouped_area_entered")
	connect("grouped_area_exited", self, "_on_grouped_area_exited")
	connect("grouped_body_entered", self, "_on_grouped_body_entered")
	connect("grouped_body_exited", self, "_on_grouped_body_exited")

func _physics_process(delta):
	if trigger_type == TRIGGER_TYPE.INSIDE:
		if is_area_colliding or is_body_colliding:
			_emit_effect()

func _on_grouped_area_entered(_area: Area2D) -> void:
	if trigger_type == TRIGGER_TYPE.ENTER:
		_emit_effect()

func _on_grouped_area_exited(_area: Area2D) -> void:
	if trigger_type == TRIGGER_TYPE.EXIT:
		_emit_effect()

func _on_grouped_body_entered(_body: Node) -> void:
	if trigger_type == TRIGGER_TYPE.ENTER:
		_emit_effect()

func _on_grouped_body_exited(_body: Node) -> void:
	if trigger_type == TRIGGER_TYPE.EXIT:
		_emit_effect()

func _check_one_shot() -> void:
	if one_shot:
		disable_all_shapes()

func _emit_effect() -> void:
	_check_one_shot()
	emit_signal("effect")
