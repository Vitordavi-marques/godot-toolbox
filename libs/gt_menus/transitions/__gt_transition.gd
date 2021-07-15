extends Node
class_name GTScreenTransition, "res://libs/gt_menus/transitions/gt_transition.svg"

export (NodePath) var screen_path
onready var screen = get_node(screen_path)
onready var tween = $Tween
onready var v_timer = $VisibilityTimer
export (float) var anim_time = 1.0


func _ready():
	assert(screen_path != null and not screen_path.is_empty())
	v_timer.wait_time = anim_time


func enter():
	pass


func exit():
	pass


func disable_screen():
	screen.visible = false
