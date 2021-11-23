extends Area2D
class_name GTHurtbox2D

signal took_damage(damage) # Took damage by contact

func _ready():
	connect("area_entered", self, "_take_damage")

func _take_damage(area):
	var damage = area.damage
	emit_signal("took_damage", damage)
