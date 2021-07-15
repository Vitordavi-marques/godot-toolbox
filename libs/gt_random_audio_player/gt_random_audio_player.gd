extends AudioStreamPlayer
class_name GTRandomAudioPlayer

export (Array, AudioStream) var samples

func _ready():
	randomize()

func play_random(from_position : float = 0.0):
	if samples.size() > 0:
		var rand_index = randi() % samples.size()
		stream = samples[rand_index]
		play(from_position)
