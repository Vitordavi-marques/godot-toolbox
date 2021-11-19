extends Node
class_name GTState

signal state_entered()
signal state_exited()

export (NodePath) var _fsm_path # State machine's path
export (NodePath) var _enter_animation_player_path # Enter Animation Player path
export (NodePath) var _exit_animation_player_path # Exit Animation Player path

var fsm : Node # This state's GTStateMachine node
var enter_animation_player : AnimationPlayer # This state's enter AnimationPlayer node
var exit_animation_player : AnimationPlayer # This state's exit AnimationPlayer node
var entity : Node # The state machine's entity

export (String) var anim_name_on_enter = "" # Name of the animation to play when entering this state
export (String) var anim_name_on_exit = "" # Name of the animation to play when exiting this state
export (bool) var play_on_enter = false # Play animation on enter
export (bool) var play_on_exit = false # Play animation on exit

export (bool) var do_input = true # Enable _input callback
export (bool) var do_process = true # Enable _process callback
export (bool) var do_physics_process = true # Enable _physics_process callback

func _ready():
	fsm = get_node(_fsm_path)
	enter_animation_player = get_node(_enter_animation_player_path)
	exit_animation_player = get_node(_exit_animation_player_path)
	assert(fsm != null, "Error initializing GTState, 'fsm' property is null")
	assert(enter_animation_player != null, "Error initializing GTState, 'enter_animation_player' property is null")
	assert(exit_animation_player != null, "Error initializing GTState, 'exit_animation_player' property is null")

# Callback for when this state becomes the state machine's current state
func enter(info: Dictionary = {}) -> void:
	pass

# Callback for when this state is substituted by another current state
func exit() -> void:
	pass

# Overridable input callback
func input(event: InputEvent) -> void:
	pass

# Overridable process callback
func process(_delta: float) -> void:
	pass

# Overridable physics_process callback
func physics_process(_delta: float) -> void:
	pass
