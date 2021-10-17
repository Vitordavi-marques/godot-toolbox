extends Node
class_name GTState

signal state_entered()
signal state_exited()

export (NodePath) var _fsm_path # State machine's path

var fsm : Node # This state's GTStateMachine node
var entity : Node # The state machine's entity

export (bool) var do_input = true # Enable _input callback
export (bool) var do_process = true # Enable _process callback
export (bool) var do_physics_process = true # Enable _physics_process callback

func _ready():
	fsm = get_node(_fsm_path)
	assert(fsm != null, "Error initializing GTState, 'fsm' property is null")

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
