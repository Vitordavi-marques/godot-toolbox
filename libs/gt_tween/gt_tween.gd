extends Tween
class_name GTTween

signal updated_property(value)

export (Resource) var curve
var _animating = [] # Current properties being animated
var _objects_to_remove = []

func _ready():
	assert(curve != null, "Error initializing GTTween: 'curve' property is null")

func _process(delta):
	for object in _objects_to_remove:
		var index = _animating.find(object)
		_animating.remove(index)
	_objects_to_remove.clear()

func play(_object: Object, _property: String, _start, _end, duration: float, _curve = null):
	var curve_to_use = _curve if _curve != null else curve
	var new_property = GTTweenProperty.new(_object, _property, _start, _end, curve_to_use)
	_animating.append(new_property)
	new_property.connect("finished", self, "_on_tween_property_finished")
	interpolate_property(new_property, "current_t", 0.0, 1.0, duration, TRANS_LINEAR, EASE_IN)
	start()

func _on_tween_property_finished(_object):
	_objects_to_remove.append(_object)

class GTTweenProperty:
	signal finished(_object)
	
	var object : Object
	var property : String
	var start
	var end
	var curve
	var current_t : float = 0.0 setget _set_current_t
	var current_value setget _set_current_value
	var is_finished : bool = false
	
	func _init(_object: Object, _property: String, _start, _end, _curve):
		object = _object
		property = _property
		start = _start
		end = _end
		curve = _curve
		current_t = 0.0
		current_value = start
		is_finished = false
	
	func _set_current_t(_value):
		current_t = _value
		self.current_value = start + ((end-start) * curve.interpolate(current_t))
		if current_t >= 1.0 and not is_finished:
			emit_signal("finished", self)
			is_finished = true
	
	func _set_current_value(_value):
		current_value = _value
		object.set(property, current_value)
