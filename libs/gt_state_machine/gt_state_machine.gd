extends Node
class_name GTStateMachine, "res://libs/gt_state_machine/icons/gt_state_machine.svg"

signal state_changed(old_state, new_state)

export (NodePath) var actor_path
export (bool) var is_active : bool = true
export (bool) var debug_mode : bool = false
var actor : Node
var current_state : Node

func _ready():
	var child_states = 0
	for child in get_children():
		if child is GTState:
			child_states += 1
	assert(actor_path != null and not actor_path.is_empty(), "%s (%s) has no actor_path set" % [self.name, self])
	assert(child_states > 0, "%s (%s) has no child states" % [self.name, self])
	actor = get_node(actor_path)
	actor.connect("ready", self, "initialize")

func initialize() -> void:
	current_state = get_child(0)
	current_state.actor = actor
	current_state.enter({})
	current_state.emit_signal("state_entered")

func change_state(new_state: Node, info: Dictionary = {}) -> void:
	if is_active:
		var old_state = current_state
		current_state.exit()
		current_state.emit_signal("state_exited")
		current_state = new_state
		current_state.actor = actor
		current_state.enter(info)
		current_state.emit_signal("state_entered")
		emit_signal("state_changed", old_state, new_state)

func change_state_path(new_state_path: String, info: Dictionary = {}) -> void:
	change_state(get_node(new_state_path), info)

func disable() -> void:
	is_active = false

func enable() -> void:
	is_active = true

func _input(event):
	if is_active and current_state.has_method("input") and current_state.do_input:
		current_state.input(event)

func _process(delta):
	if is_active and current_state.has_method("process") and current_state.do_process:
		current_state.process(delta)

func _physics_process(delta):
	if debug_mode:
		print(current_state.name)
	if is_active and current_state.has_method("physics_process") and current_state.do_physics_process:
		current_state.physics_process(delta)
