extends Node
class_name GTStateMachine, "res://libs/gt_state_machine/icons/gt_state_machine.svg"

signal state_changed(old_state, new_state)

export (NodePath) var _entity_path
export (bool) var is_enabled : bool = true # Whether this node is enabled or not
export (bool) var _debug_mode : bool = false

var entity : Node # This state machine's owner entity
var current_state : Node # Current state node

func _ready():
	var child_states = 0
	for child in get_children():
		if child is GTState:
			child_states += 1
	entity = get_node(_entity_path)
	assert(entity != null, "Error initializing GTStateMachine, 'entity' property is null")
	assert(child_states > 0, "Error initializing GTStateMachine, there is no child GTState node")
	entity.connect("ready", self, "_initialize")

func _initialize() -> void:
	current_state = get_child(0)
	current_state.entity = entity
	current_state.enter({})
	if current_state.play_on_enter:
		current_state.animation_player.stop()
		current_state.animation_player.play(current_state.anim_name_on_enter)
	current_state.emit_signal("state_entered")

# Change state to 'new_state' GTState node, passing optional aditional info
func change_state(new_state: Node, info: Dictionary = {}) -> void:
	if is_enabled:
		var old_state = current_state
		current_state.exit()
		if current_state.play_on_exit:
			current_state.animation_player.stop()
			current_state.animation_player.play(current_state.anim_name_on_exit)
		current_state.emit_signal("state_exited")
		current_state = new_state
		current_state.entity = entity
		current_state.enter(info)
		if current_state.play_on_enter:
			current_state.animation_player.stop()
			current_state.animation_player.play(current_state.anim_name_on_enter)
		current_state.emit_signal("state_entered")
		emit_signal("state_changed", old_state, new_state)

# Change state to node using node path 'new_state_path'
func change_state_path(new_state_path: String, info: Dictionary = {}) -> void:
	change_state(get_node(new_state_path), info)

# Disables this node's functionality
func disable() -> void:
	is_enabled = false

# Disables this node's functionality
func enable() -> void:
	is_enabled = true

func _input(event):
	if is_enabled and current_state.has_method("input") and current_state.do_input:
		current_state.input(event)

func _process(delta):
	if is_enabled and current_state.has_method("process") and current_state.do_process:
		current_state.process(delta)

func _physics_process(delta):
	if _debug_mode:
		print(current_state.name)
	if is_enabled and current_state.has_method("physics_process") and current_state.do_physics_process:
		current_state.physics_process(delta)
