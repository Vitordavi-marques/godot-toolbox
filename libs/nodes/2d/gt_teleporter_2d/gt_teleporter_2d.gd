extends Area2D
class_name GTTeleporter2D

signal teleported_entity(cause, entity)

var _CONNECTOR_GROUP : String = "gt_teleporter_2d" # The group string used for identifying other teleporters

export (bool) var is_cause = true # Whether this is an entrance, or exit teleporter
export (bool) var is_indirect = false # Whether this node uses the colliding node directly, or the node contained in its 'body' property
export (String) var tag = "default" # This teleporter' tag, used as an ID
export (float) var delay = 1.0 # The delay before the teleport

var _delay_timer : Timer
var _entity_to_teleport : Node
var _pos_to_teleport : Vector2

func _ready():
	add_to_group(_CONNECTOR_GROUP)
	_delay_timer = Timer.new()
	_delay_timer.one_shot = true
	add_child(_delay_timer)
	_delay_timer.connect("timeout", self, "_perform_teleport")
	connect("area_entered", self, "__on_area_entered")
	connect("body_entered", self, "__on_body_entered")

func __on_area_entered(area) -> void:
	if is_cause:
		get_tree().call_group(_CONNECTOR_GROUP, "_teleport", self, area)

func __on_body_entered(body) -> void:
	if is_cause:
		get_tree().call_group(_CONNECTOR_GROUP, "_teleport", self, body)

func _teleport(cause, entity) -> void:
	if tag == cause.tag and not is_cause:
		_pos_to_teleport = global_position
		_entity_to_teleport = entity if not is_indirect else entity.body
		if delay > 0.0:
			_delay_timer.start()
		else:
			_perform_teleport()
		emit_signal("teleported_entity", cause, entity)

func _perform_teleport() -> void:
	if _entity_to_teleport and _pos_to_teleport != Vector2.ZERO:
		_entity_to_teleport.global_position = _pos_to_teleport
