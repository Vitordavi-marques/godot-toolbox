extends GTArea2D
class_name GTTeleporter2D

signal teleported_entity(cause, entity)

var CONNECTOR_GROUP : String = "gt_teleporter_2d"

export (bool) var is_cause = true
export (bool) var is_indirect = false
export (String) var tag = "default"

func _ready():
	add_to_group(CONNECTOR_GROUP)
	connect("grouped_area_entered", self, "_on_grouped_area_entered")
	connect("grouped_body_entered", self, "_on_grouped_body_entered")

func _on_grouped_area_entered(area):
	if is_cause:
		get_tree().call_group(CONNECTOR_GROUP, "teleport", self, area)

func _on_grouped_body_entered(body):
	if is_cause:
		get_tree().call_group(CONNECTOR_GROUP, "teleport", self, body)

func teleport(cause, entity):
	if tag == cause.tag and not is_cause:
		if not is_indirect:
			entity.global_position = global_position
		else:
			entity.actor.global_position = global_position
		emit_signal("teleported_entity", cause, entity)
