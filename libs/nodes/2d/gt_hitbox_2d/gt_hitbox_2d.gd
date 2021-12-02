extends Area2D
class_name GTHitbox2D

signal caused_damage(damage) # Caused damage by contact

export (int) var damage setget set_damage # Damage dealt upon contact

func _ready():
	connect("area_entered", self, "_cause_damage")

func _cause_damage(_area):
	emit_signal("caused_damage", damage)

func set_damage(_value):
	damage = _value

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
