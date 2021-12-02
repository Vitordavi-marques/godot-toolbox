extends Area2D
class_name GTHurtbox2D

signal took_damage(damage) # Took damage by contact

func _ready():
	connect("area_entered", self, "_take_damage")

func _take_damage(area):
	if "damage" in area:
		var damage = area.damage
		emit_signal("took_damage", damage)

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
