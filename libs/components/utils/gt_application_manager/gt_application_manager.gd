extends Node

enum SCENES {
	MAIN = 1,
	GAME = 2}

const SCENES_PATH = {
	SCENES.MAIN : "res://main/main.tscn",
	SCENES.GAME : "res://main/game/game.tscn"}

func load_scene(scene: int):
	if SCENES.values().has(scene):
		get_tree().change_scene(SCENES_PATH[scene])

func reload():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()
