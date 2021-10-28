extends GTTriggerArea2D
class_name GTHitbox2D

signal caused_damage(damage) # Caused damage by contact

export (int) var damage setget set_damage # Damage dealt upon contact

func _ready():
	connect("effect", self, "_cause_damage")

func _cause_damage():
	emit_signal("caused_damage", damage)

func set_damage(_value):
	damage = _value
