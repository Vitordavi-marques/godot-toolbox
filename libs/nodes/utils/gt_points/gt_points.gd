extends Node
class_name GTPoints, "res://libs/nodes/icons/two-coins.svg"

signal points_updated(current)
signal points_gained(current, gained)
signal points_lost(current, lost)

export (int) var initial_points = 0

onready var current_points = initial_points

func gain_points(amount: int = 1) -> void:
	current_points += amount
	emit_signal("points_updated", current_points)
	emit_signal("points_gained", current_points, amount)

func lose_points(amount: int = 1) -> void:
	current_points -= amount
	emit_signal("points_updated", current_points)
	emit_signal("points_lost", current_points, amount)

func set_points(amount: int) -> void:
	current_points = amount
	emit_signal("points_updated", current_points)

func clear_points() -> void:
	lose_points(current_points)
