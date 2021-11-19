extends Node

const MUSIC_CHANNEL = "Music"
const SOUND_CHANNEL = "Sound"

var music_volume : float
var sound_volume : float

func _ready():
	change_music_volume(0.5)
	change_sound_volume(0.5)

func change_music_volume(new_volume: float):
	music_volume = new_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_CHANNEL),linear2db(new_volume))

func change_sound_volume(new_volume: float):
	sound_volume = new_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SOUND_CHANNEL),linear2db(new_volume))
