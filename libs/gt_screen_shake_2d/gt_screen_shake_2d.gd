extends Node
class_name GTScreenShake2D

export (NodePath) var camera_path
export (Vector2) var movement_mask = Vector2(1, 1)
export (bool) var is_active = true
onready var camera = get_node(camera_path)
var tween
var frequency_timer
var duration_timer

var is_playing : bool = false
var current_intensity : float = 0.0
var current_direction : Vector2


func _ready():
	assert(camera != null, "There is no Camera2D set for %s" % [self.name])
	tween = Tween.new()
	add_child(tween)
	frequency_timer = Timer.new()
	frequency_timer.one_shot = true
	add_child(frequency_timer)
	duration_timer = Timer.new()
	duration_timer.one_shot = true
	add_child(duration_timer)
	frequency_timer.connect("timeout", self, "_on_FrequencyTimer_timeout")
	duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")


func shake_simple(_intensity: float = 8.0, duration: float = 0.5, frequency: float = 0.1, direction: Vector2 = Vector2.ZERO):
	if not is_active:
		return
	current_intensity = _intensity
	is_playing = true
	
	frequency_timer.wait_time = frequency
	duration_timer.wait_time = duration
	frequency_timer.start()
	duration_timer.start()
	_shake(direction)


func _shake(direction: Vector2 = Vector2.ZERO):
	if direction == Vector2.ZERO:
		direction = Utils.rand_direction()
	current_direction = direction
	
	var new_offset = direction * current_intensity
	tween.interpolate_property(camera, "offset", camera.offset, new_offset, frequency_timer.wait_time)
	tween.start()

func _on_FrequencyTimer_timeout():
	if is_playing:
		frequency_timer.start()
		_shake(-current_direction)

func _on_DurationTimer_timeout():
	is_playing = false
	tween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, frequency_timer.wait_time)
	tween.start()
