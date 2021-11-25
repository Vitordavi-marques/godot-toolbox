extends Node
class_name GTStateMachine, "res://libs/nodes/icons/vertical-graph.svg"

signal state_changed(current)

const STR_PREVIOUS = "previous"

export (NodePath) var _entity_path
export (NodePath) var starting_state
export (bool) var is_enabled : bool = true # Whether this node is enabled or not
export (bool) var _debug_mode : bool = false

var entity : Node # This state machine's owner entity
var current_state : Node # Current state node
var states_map = {}
var states_names = {}

func _ready():
	entity = get_node(_entity_path)
	assert(entity, "Error initializing GTStateMachine: 'entity' property is null")
	entity.connect("ready", self, "_initialize")

func _initialize():
	if not starting_state:
		starting_state = get_child(0).get_path()
	var queue = [self]
	while not queue.empty():
		var n = queue.size()
		while n > 0:
			var node = queue.pop_front()
			if node != self:
				_init_state(node)
			for child in node.get_children():
				queue.append(child)
			n -= 1
	_enter_state(get_node(starting_state), {})

func _init_state(node):
	if node is GTState:
		var path_to_node = get_path_to(node)
		var node_name = Utils.node_path_to_str(path_to_node)
		states_map[node_name] = node
		states_names[node] = node_name
		assert(node.has_signal("finished"), "Error initializing GTStateMachine: %s child has no 'finished' signal" % [node.name])
		node.connect("finished", self, "change_state")

func _enter_state(state: Node, info: Dictionary):
	current_state = state
	current_state.fsm = self
	current_state.entity = entity
	current_state.enter(info)
	current_state.emit_signal("state_entered")

func _exit_state():
	current_state.exit()
	current_state.emit_signal("state_exited")

func change_state(state_name: String, info: Dictionary = {}):
	if not is_enabled:
		return
	_exit_state()
	var state = states_map[state_name]
	_enter_state(state, info)
	emit_signal("state_changed", current_state)

# Disables this node's functionality
func enable() -> void:
	is_enabled = true

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Delegate input function to current state
func _input(event):
	if is_enabled and current_state:
		current_state.input(event)

# Delegate process function to current state
func _process(delta):
	if is_enabled and current_state:
		current_state.process(delta)

# Delegate physics process function to current state
func _physics_process(delta):
	if _debug_mode:
		print(states_names[current_state])
	if is_enabled and current_state:
		current_state.physics_process(delta)
