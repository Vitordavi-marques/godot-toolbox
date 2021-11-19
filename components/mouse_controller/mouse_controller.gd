extends Node
class_name MouseController, "res://libs/icons/gamepad-white.svg"

signal updated_screen_position(pos)
signal updated_global_position(pos)

export (NodePath) var _current_camera_path
export (bool) var use_icon = false
export (bool) var debug_mode = false

var mouse_screen_position : Vector2
var mouse_global_position : Vector2
var current_camera

onready var mouse_pos = $CanvasLayer/mouse_pos

func _ready():
	mouse_pos.visible = use_icon
	if use_icon:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if debug_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if _current_camera_path:
		current_camera = get_node(_current_camera_path)
		assert(current_camera is Camera2D, "Error initializing MouseControllerComponent: 'current_camera' is not a Camera2D node")

func _physics_process(delta):
	var pos = get_viewport().get_mouse_position()
	mouse_screen_position = pos / Utils.get_screen_size()
	var distance_from_center = mouse_screen_position - Vector2.ONE/2
	var pos_pivot = current_camera.global_position if current_camera else Utils.get_screen_size()*Vector2.ONE/2
	var dist_from_center_global = distance_from_center*Utils.get_screen_size()
	mouse_global_position = pos_pivot + dist_from_center_global
	mouse_pos.global_position = pos
	
	emit_signal("updated_screen_position", mouse_screen_position)
	emit_signal("updated_global_position", mouse_global_position)
