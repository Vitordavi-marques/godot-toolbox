extends GTArea2D
class_name GTTriggerArea2D

signal effect()

enum TRIGGER_TYPE { ENTER = 0, INSIDE = 1, EXIT = 2 }

export (TRIGGER_TYPE) var trigger_type = TRIGGER_TYPE.ENTER
export (bool) var one_shot = false

func _ready():
	connect("grouped_area_entered", self, "_on_grouped_area_entered")
	connect("grouped_area_exited", self, "_on_grouped_area_exited")
	connect("grouped_body_entered", self, "_on_grouped_body_entered")
	connect("grouped_body_exited", self, "_on_grouped_body_exited")

func _physics_process(delta):
	if trigger_type == TRIGGER_TYPE.INSIDE:
		if is_area_colliding or is_body_colliding:
			emit_effect()

func _on_grouped_area_entered(_area: Area2D):
	if trigger_type == TRIGGER_TYPE.ENTER:
		emit_effect()

func _on_grouped_area_exited(_area: Area2D):
	if trigger_type == TRIGGER_TYPE.EXIT:
		emit_effect()

func _on_grouped_body_entered(_body: Node):
	if trigger_type == TRIGGER_TYPE.ENTER:
		emit_effect()

func _on_grouped_body_exited(_body: Node):
	if trigger_type == TRIGGER_TYPE.EXIT:
		emit_effect()

func check_one_shot():
	if one_shot:
		disable_all_shapes()

func emit_effect():
	check_one_shot()
	emit_signal("effect")
