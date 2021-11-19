extends Node
class_name GTTimeScale, "res://libs/nodes/icons/hourglass.svg"

var _pause_timer : Timer
var _count_timer : Timer
var time_scale : float # Current time scale

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	_pause_timer = Timer.new()
	_pause_timer.one_shot = true
	_count_timer = Timer.new()
	_count_timer.one_shot = true
	add_child(_pause_timer)
	add_child(_count_timer)
	_pause_timer.connect("timeout", self, "resume_time")
	_count_timer.connect("timeout", self, "normalize_time")

# Freezes time for a certain duration, or indefinetly
func pause_time(seconds: float = 0.0) -> void:
	if seconds > 0.0:
		_pause_timer.stop()
		_pause_timer.wait_time = seconds
		_pause_timer.start()
	get_tree().paused = true

# Resumes frozen time
func resume_time() -> void:
	get_tree().paused = false

# Slows down time by a certain factor, for a certain duration (or indefinetly)
func slow_time(scale: float, duration: float = 0.0) -> void:
	if duration > 0.0:
		_count_timer.stop()
		_count_timer.wait_time = duration * scale
		_count_timer.start()
	time_scale = scale
	Engine.time_scale = time_scale

# Normalizes the flow of time
func normalize_time() -> void:
	time_scale = 1.0
	Engine.time_scale = 1.0

func set_time_scale(amount: float) -> void:
	time_scale = amount
	Engine.time_scale = time_scale
