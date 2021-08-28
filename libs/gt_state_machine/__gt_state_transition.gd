extends Node
class_name GTStateTransition

signal transition_done()

export (NodePath) var end_state_path
export (bool) var is_active = true
var start_state : Node
var end_state : Node

var info_for_transition = {}

func _ready():
	assert(get_parent() is GTState)
	start_state = get_parent()
	end_state = get_node(end_state_path)

func set_info(info: Dictionary) -> void:
	info_for_transition = info

func can_transition() -> bool:
	return is_active and start_state.fsm.current_state == start_state

func do_transition():
	if can_transition():
		start_state.fsm.change_state(end_state, info_for_transition)
		emit_signal("transition_done")
