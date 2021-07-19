extends Node
class_name GTHealth

signal health_updated(current)
signal health_gained(current, gained)
signal health_lost(current, lost)
signal gibbed(current)
signal died(current)

export (int) var MAX_HEALTH = 100
export (int) var INITIAL_HEALTH = 100

export (int) var GIB_THRESHOLD = -50

var is_alive : bool = true
onready var current_health = INITIAL_HEALTH

func gain_health(amount: int):
	current_health += amount
	current_health = clamp(current_health, current_health, MAX_HEALTH)
	emit_signal("health_updated", current_health)
	emit_signal("health_gained", current_health, amount)

func lose_health(amount: int):
	current_health -= amount
	current_health = clamp(current_health, current_health, MAX_HEALTH)
	
	if current_health <= 0:
		is_alive = false
		emit_signal("died", current_health)
		if current_health <= GIB_THRESHOLD:
			emit_signal("gibbed", current_health)
	
	emit_signal("health_updated", current_health)
	emit_signal("health_lost", current_health, amount)
