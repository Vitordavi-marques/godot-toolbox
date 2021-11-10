extends Node
class_name GTSteeringBehavior2D

export (bool) var is_enabled = true

var actor : Node

func _ready():
	actor = get_parent()
	assert(actor != null, "Error initializing GTSteeringBehavior2D, 'actor' property is null")

func move(delta):
	pass
