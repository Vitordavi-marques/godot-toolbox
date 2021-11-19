extends Node
class_name GTHealth, "res://libs/icons/health.svg"

signal health_updated(current)
signal health_gained(current, gained)
signal health_lost(current, lost)
signal lived()
signal died()

export (int) var max_health = 100 # Maximum health achievable
export (int) var initial_health = 100 # Initial health upon initialization
export (bool) var _debug_mode = false

var is_alive : bool = true # Is alive or not
var current_health : int # Current health

func _ready():
	current_health = initial_health

func _process(delta):
	if _debug_mode: print(current_health)

func _check_is_alive():
	if current_health <= 0:
		if is_alive:
			emit_signal("died")
		is_alive = false
	else:
		is_alive = true
		emit_signal("lived")

# Adds 'amount' to current health
func gain_health(amount: int) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_updated", current_health)
	emit_signal("health_gained", current_health, amount)

# Subtracts 'amount' from current health
func lose_health(amount: int) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	_check_is_alive()
	emit_signal("health_updated", current_health)
	emit_signal("health_lost", current_health, amount)

# Set health directly
func set_health(amount: int) -> void:
	current_health = amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_updated", current_health)
