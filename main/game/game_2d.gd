extends Node2D

export (bool) var randomize_on_ready = false

func _ready():
	if randomize_on_ready:
		randomize()

func add_entity(entity):
	add_child(entity)
