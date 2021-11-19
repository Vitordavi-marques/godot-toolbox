extends Node2D

const SCREEN_CENTER = Vector2.ONE/2

export (Vector2) var screen_size = Vector2(640, 360)
export (float) var dead_zone = 160.0
export (float) var strength = 0.5
export (bool) var is_enabled = true

onready var camera = $Camera

var mouse_position : Vector2

func _physics_process(delta):
	if not is_enabled:
		return
	var dir = (mouse_position-SCREEN_CENTER)*screen_size
	if dir.length() < dead_zone:
		position = Vector2.ZERO
	else:
		position = dir.normalized()*(dir.length()-dead_zone)*strength

func set_mouse_position(_pos):
	mouse_position = _pos
