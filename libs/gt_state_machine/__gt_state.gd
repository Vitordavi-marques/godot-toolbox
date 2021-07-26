extends Node
class_name GTState

signal state_entered()
signal state_exited()

export (NodePath) var fsm_path
var fsm : Node
var actor : Node

export (bool) var do_input = true
export (bool) var do_process = true
export (bool) var do_physics_process = true


func _ready():
	fsm = get_node(fsm_path)
	assert(fsm_path != null and not fsm_path.is_empty(), "%s (%s) has no fsm_path set" % [self.name, self])

func enter(info: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func input(event: InputEvent) -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
