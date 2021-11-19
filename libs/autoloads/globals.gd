extends Node

enum ENTITY_TYPES {
	NULL = 0}

func get_game():
	if has_node("/root/Game"):
		return get_node("/root/Game")
	else:
		return get_tree().root.get_child(get_tree().root.get_child_count()-1)
