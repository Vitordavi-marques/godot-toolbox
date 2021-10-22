extends Node
class_name GTStateTransition

signal transition_done()

export (NodePath) var _end_state_path

export (bool) var is_enabled = true # Whether this transition is enabled or not
var start_state : Node # Starting node before transition
var end_state : Node # Node that will be transitioned to

var _info_for_transition = {}

func _ready():
	start_state = get_parent()
	end_state = get_node(_end_state_path)
	assert(get_parent() is GTState, "Error initializing GTStateTransition, parent is not a GTState")
	assert(end_state, "Error initializing GTStateTransition, 'end_state' property is null")

# Set info dictionary for end_state node
func set_info(info: Dictionary) -> void:
	_info_for_transition = info

func _can_transition() -> bool:
	return is_enabled and start_state.fsm.current_state == start_state

# Performs the transition
func do_transition():
	if _can_transition():
		start_state.fsm.change_state(end_state, _info_for_transition)
		emit_signal("transition_done")

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true
