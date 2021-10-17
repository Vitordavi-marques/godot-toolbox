extends Node
class_name ApplicationManager

enum SCENES {
	MAIN,
	GAME_2D,
	GAME_3D}

const SCENES_PATH = {
	SCENES.MAIN : "res://main/main.tscn",
	SCENES.GAME_2D : "res://main/game/game_2d.tscn",
	SCENES.GAME_3D : "res://main/game/game_3d.tscn"}

func load_scene(scene: int):
	if SCENES.values().has(scene):
		get_tree().change_scene(SCENES_PATH[scene])

func reload():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()
