extends Node
class_name GTStateMachine, "res://libs/gt_state_machine/gt_state_machine.svg"

export (NodePath) var actor_path
export (bool) var is_active : bool = true
var actor
var current_state


func _ready():
	assert(actor_path != null and not actor_path.is_empty())
	if actor_path:
		actor = get_node(actor_path)
	actor.connect("ready", self, "_on_Actor_ready")


func _on_Actor_ready() -> void:
	if is_active:
		current_state = get_child(0)
		current_state.actor = actor
		current_state.enter({})
		current_state.emit_signal("state_entered")


func change_state(new_state, info = {}) -> void:
	if is_active:
		current_state.exit()
		current_state.emit_signal("state_exited")
		current_state = new_state
		current_state.actor = actor
		current_state.enter(info)
		current_state.emit_signal("state_entered")


func change_state_by_path(new_state_path, info = {}) -> void:
	change_state(get_node(new_state_path), info)


func _input(event):
	if is_active and current_state.has_method("input") and current_state.do_input:
		current_state.input(event)


func _process(delta):
	if is_active and current_state.has_method("process") and current_state.do_process:
		current_state.process(delta)


func _physics_process(delta):
#	print(current_state.name)
	if is_active and current_state.has_method("physics_process") and current_state.do_physics_process:
		current_state.physics_process(delta)


func disable():
	is_active = false

func enable():
	is_active = true
