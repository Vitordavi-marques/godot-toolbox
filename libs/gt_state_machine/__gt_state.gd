extends Node
class_name GTState

signal state_entered()
signal state_exited()

export (NodePath) var fsm_path
onready var fsm = get_node(fsm_path)
var actor

export (bool) var do_input = true
export (bool) var do_process = true
export (bool) var do_physics_process = true


func _ready():
	assert(fsm_path != null and not fsm_path.is_empty())


func enter(info):
	pass


func exit():
	pass


func input(event):
	pass


func process(_delta):
	pass


func physics_process(_delta):
	pass
