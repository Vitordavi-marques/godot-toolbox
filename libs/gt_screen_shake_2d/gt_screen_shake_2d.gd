extends Node
class_name GTScreenShake2D

export (NodePath) var camera_path
export (bool) var move_x = true
export (bool) var move_y = true

onready var camera = get_node(camera_path)
onready var tween = $Tween
onready var frequency_timer = $FrequencyTimer
onready var duration_timer = $DurationTimer

var is_active : bool = false
var current_intensity : float = 0.0


func _ready():
	assert(camera != null, "There is no Camera2D set for %s" % [self.name])
	assert(tween != null, "There is no Tween set for %s" % [self.name])
	assert(frequency_timer != null, "There is no FrequencyTimer set for %s" % [self.name])
	assert(duration_timer != null, "There is no DurationTimer set for %s" % [self.name])
	randomize()


func screen_shake_simple(_intensity: float, duration: float, frequency: float):
	current_intensity = _intensity
	is_active = true
	
	frequency_timer.wait_time = frequency
	duration_timer.wait_time = duration
	frequency_timer.start()
	duration_timer.start()
	shake()


func shake():
	var direction = Vector2.ZERO
	direction.x = int(move_x) * randf()
	direction.y = int(move_y) * randf()
	
	var new_offset = direction * current_intensity
	tween.interpolate_property(camera, "offset", camera.offset, new_offset, frequency_timer.wait_time)
	tween.start()

func _on_FrequencyTimer_timeout():
	if is_active:
		shake()

func _on_DurationTimer_timeout():
	is_active = false
	tween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, frequency_timer.wait_time)
	tween.start()
