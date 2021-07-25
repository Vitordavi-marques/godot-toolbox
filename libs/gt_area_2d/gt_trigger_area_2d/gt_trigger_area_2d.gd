extends GTArea2D
class_name GTTriggerArea2D

signal effect()

enum TRIGGER_TYPE { ENTER, INSIDE, EXIT }

export (TRIGGER_TYPE) var trigger_type = TRIGGER_TYPE.ENTER

func _ready():
	connect("area_entered", self, "_on_grouped_area_entered")
	connect("area_exited", self, "_on_grouped_area_exited")
	connect("body_entered", self, "_on_grouped_body_entered")
	connect("body_exited", self, "_on_grouped_body_exited")

func _physics_process(delta):
	if trigger_type == TRIGGER_TYPE.INSIDE:
		if is_area_colliding or is_body_colliding:
			emit_signal("effect")

func _on_grouped_area_entered(_area: Area2D):
	if trigger_type == TRIGGER_TYPE.ENTER:
		emit_signal("effect")

func _on_grouped_area_exited(_area: Area2D):
	if trigger_type == TRIGGER_TYPE.EXIT:
		emit_signal("effect")

func _on_grouped_body_entered(_body: Node):
	if trigger_type == TRIGGER_TYPE.ENTER:
		emit_signal("effect")

func _on_grouped_body_exited(_body: Node):
	if trigger_type == TRIGGER_TYPE.EXIT:
		emit_signal("effect")
