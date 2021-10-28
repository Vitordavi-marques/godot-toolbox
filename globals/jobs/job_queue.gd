extends Node

var _timer : Timer

var seconds_between_ticks : float = 0.016
var calls_per_tick : int = 10
var queue = {}

func _ready():
	_timer = Timer.new()
	_timer.name = "_Timer"
	add_child(_timer)
	_timer.one_shot = true
	_timer.wait_time = seconds_between_ticks
	_timer.connect("timeout", self, "tick")
	_timer.start()

func tick():
	for key in queue.keys():
		var jobs_executed = 0
		for job in queue[key]:
			job.execute()
			queue[key].pop_front()
			jobs_executed += 1
			if jobs_executed >= calls_per_tick:
				break
	_timer.start()

func set_seconds_between_ticks(_seconds: float):
	seconds_between_ticks = _seconds
	_timer.wait_time = seconds_between_ticks
	_timer.start()

func set_calls_per_tick(_calls: int):
	calls_per_tick = _calls

func schedule(tag: String, _object: Object, _name: String, _args: Array):
	if not queue.has(tag):
		queue[tag] = []
	var job = Job.new(_object, _name, _args)
	queue[tag].append(job)

class Job:
	var object : Object
	var method_name : String
	var method_args : Array
	
	func _init(_object: Object, _name: String, _args: Array):
		object = _object
		method_name = _name
		method_args = _args
	
	func execute():
		if method_args.size() > 0:
			object.call(method_name, method_args)
		else:
			object.call(method_name)
