extends Node
class_name LevelLoader

signal level_started()
signal level_finished()

export (NodePath) var _world_path # Path to world parent node
export (float) var delay_on_level_load = 0.2 # Delay on level load

var world : Node # World parent node
var level : Node # The node with the current level loaded
var current_level_id : int # The id of the current level

var _has_level_to_load : bool = true # Whether or not this script should load a level in _process
var _level_uuid : int = 0 # Unique id for level node name (independent of level id)
var _delay_timer : Timer # Delay timer for level loading

func _ready():
	world = get_node(_world_path)
	assert(world != null, "Error initializing LevelLoader, 'world' property is null")
	assert("level_scenes" in world, "Error initializing LevelLoader, 'world' property has no 'level_scenes' property")
	_delay_timer = Timer.new()
	_delay_timer.wait_time = delay_on_level_load
	_delay_timer.one_shot = true
	_delay_timer.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(_delay_timer)

func _process(delta):
	if not _has_level_to_load or not _delay_timer.is_stopped():
		return
	_has_level_to_load = false
	if level:
		get_node(str(_level_uuid)).call_deferred("queue_free")
	if world.LEVEL_SCENES.keys().has(current_level_id):
		level = world.LEVEL_SCENES[current_level_id].instance()
		level.connect("level_started", self, "emit_signal", ["level_started"])
		level.connect("level_finished", self, "emit_signal", ["level_finished"])
		_level_uuid += 1
		level.name = str(_level_uuid)
		level.pause_mode = Node.PAUSE_MODE_STOP
		add_child(level)

func load_level(_current_level_id, with_delay: bool):
	current_level_id = _current_level_id
	_has_level_to_load = true
	if with_delay:
		_delay_timer.start()
