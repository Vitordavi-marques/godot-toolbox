extends Node
class_name GTScreenShake2D, "res://libs/nodes/icons/static.svg"

export (NodePath) var _camera_path # Path of the Camera2D node to be affected
export (Vector2) var movement_mask = Vector2(1, 1) # Movement mask multiplier
export (bool) var is_enabled = true # Whether this node is enabled or not

var _camera : Camera2D
var _tween : Tween
var _frequency_timer : Timer
var _duration_timer : Timer

var _is_playing : bool = false # Whether the camera is currently shaking or not
var _current_intensity : float = 0.0 # Current intensity of the screen shake (in pixels)
var _current_direction : Vector2 # Current direction of the screen shake (changes randomly or not)
var _initial_direction : Vector2 # Initial direction of the screen shake (used for calculating going in-back animations)

func _ready():
	_camera = get_node(_camera_path)
	assert(_camera != null, "Error initializing GTScreenShake2D, '_camera' property is null")
	_tween = Tween.new()
	add_child(_tween)
	_frequency_timer = Timer.new()
	_frequency_timer.one_shot = true
	add_child(_frequency_timer)
	_duration_timer = Timer.new()
	_duration_timer.one_shot = true
	add_child(_duration_timer)
	_frequency_timer.connect("timeout", self, "_on_FrequencyTimer_timeout")
	_duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

# Simple camera shake with 'intensity' in pixels, 'duration' in seconds, and many sub-shakes each with 'frequency' duration
func shake(_intensity: float = 8.0, duration: float = 0.5, frequency: float = 0.1, direction: Vector2 = Vector2.ZERO) -> void:
	if not is_enabled:
		return
	_current_intensity = _intensity
	_initial_direction = direction
	_is_playing = true
	
	_frequency_timer.wait_time = frequency
	_duration_timer.wait_time = duration
	_frequency_timer.start()
	_duration_timer.start()
	_shake(direction)

func _shake(direction: Vector2 = Vector2.ZERO) -> void:
	if _initial_direction == Vector2.ZERO:
		direction = Utils.rand_direction()
	_current_direction = direction
	
	var new_offset = direction * _current_intensity
	_tween.interpolate_property(_camera, "offset", _camera.offset, new_offset, _frequency_timer.wait_time)
	_tween.start()

func _on_FrequencyTimer_timeout() -> void:
	if _is_playing:
		_frequency_timer.start()
		if _initial_direction == Vector2.ZERO:
			_shake(-_current_direction)
		else:
			_shake(_current_direction)

func _on_DurationTimer_timeout() -> void:
	_is_playing = false
	_tween.interpolate_property(_camera, "offset", _camera.offset, Vector2.ZERO, _frequency_timer.wait_time)
	_tween.start()

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true
