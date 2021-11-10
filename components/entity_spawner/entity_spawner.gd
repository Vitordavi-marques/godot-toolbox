extends Node

signal has_spawned_entity()
signal spawned_entity(entity)

export (NodePath) var _actor_path # Parent actor path
export (PackedScene) var _entity_template # Entity scene template to spawn
export (bool) var add_to_scene = true # Add to scene after initializing
export (bool) var is_independent_entity = false # Whether or not it is an independent entity (to be spawned inside Entities node in Game)

var actor # Actor that uses this component

func _ready():
	actor = get_node(_actor_path)
	assert(actor != null, "Error initializing EntitySpawner, 'actor' property is null")

func spawn():
	var info = {
		"global_position": Vector2.ZERO}
	return spawn_with_info(info)

func spawn_with_pos(pos: Vector2):
	var info = {
		"global_position": pos}
	return spawn_with_info(info)

func spawn_with_info(info: Dictionary):
	var entity = _entity_template.instance()
	_put_entity_in_scene(entity)
	_apply_info(entity, info)
	_spawn_signals(entity)
	return entity

func _apply_info(_entity, info: Dictionary):
	for key in info.keys():
		if key in _entity:
			_entity.set(key, info[key])

func _put_entity_in_scene(entity):
	if add_to_scene:
		if is_independent_entity:
			Globals.get_game().add_entity(entity)
		else:
			actor.add_child(entity)

func _spawn_signals(entity):
	emit_signal("has_spawned_entity")
	emit_signal("spawned_entity", entity)
