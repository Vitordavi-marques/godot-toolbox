extends Node
class_name GTPoints

signal points_updated(current)
signal points_gained(current, gained)
signal points_lost(current, lost)

export (int) var INITIAL_POINTS = 0

onready var current_points = INITIAL_POINTS

func gain_points(amount: int):
	current_points += amount
	emit_signal("points_updated", current_points)
	emit_signal("points_gained", current_points, amount)

func lose_points(amount: int):
	current_points -= amount
	emit_signal("points_updated", current_points)
	emit_signal("points_lost", current_points, amount)
