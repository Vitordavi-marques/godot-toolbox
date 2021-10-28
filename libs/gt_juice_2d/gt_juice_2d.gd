extends Node2D
class_name GTJuice2D

export (bool) var is_enabled = true # Whether this node is enabled or not

var _tween : Tween

func _ready():
	_tween = Tween.new()
	add_child(_tween)
	_tween.name = "_Tween"

# Simple squash and stretch (one-phase)
func simple_squash_stretch(strength: float = 0.3, time: float = 0.15) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "scale", Vector2.ONE, Vector2(1+strength,1-strength), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "scale", Vector2(1+strength,1-strength), Vector2(1-strength,1+strength), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, time/3)
	_tween.interpolate_property(self, "scale", Vector2(1-strength,1+strength), Vector2.ONE, time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2*time/3)
	_tween.start()

# Squash and stretch (two phases)
func squash_stretch(strength: float = 0.45, time: float = 0.2) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "scale", Vector2.ONE, Vector2(1+strength,1-strength), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "scale", Vector2(1+strength,1-strength), Vector2(1-strength,1+strength), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, time/5)
	_tween.interpolate_property(self, "scale", Vector2(1-strength,1+strength), Vector2(1+strength/2,1-strength/2), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2*time/5)
	_tween.interpolate_property(self, "scale", Vector2(1+strength/2,1-strength/2), Vector2(1-strength/2,1+strength/2), time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3*time/5)
	_tween.interpolate_property(self, "scale", Vector2(1-strength/2,1+strength/2), Vector2.ONE, time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 4*time/5)
	_tween.start()

# Scaling with linear easing
func simple_scale(start_size: Vector2 = Vector2.ONE, end_size: Vector2 = Vector2(1.2, 1.2), time: float = 0.3) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "scale", start_size, end_size, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()

# Scaling with bounce easing
func bounce_scale(start_size: Vector2 = Vector2.ONE, end_size: Vector2 = Vector2(1.2, 1.2), time: float = 0.3) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "scale", start_size, end_size, time, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	_tween.start()

# Rotation with quad easing
func simple_rotate(amplitude: float = 5.0, time: float = 0.15) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, amplitude, time, Tween.TRANS_QUAD, Tween.EASE_IN)
	_tween.start()

# Floating with cubic easing
func simple_float(amplitude: float = 16.0, time: float = 1.0, delay: float = 0.0) -> void:
	if not is_enabled: return
	_tween.interpolate_property(self, "position", Vector2.ZERO, Vector2.UP*amplitude, time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	_tween.interpolate_property(self, "position", Vector2.UP*amplitude, Vector2.ZERO, time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1.0 + delay)
	_tween.start()

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true
