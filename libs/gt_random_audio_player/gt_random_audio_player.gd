extends AudioStreamPlayer
class_name GTRandomAudioPlayer

export (Array, AudioStream) var samples

func choose_random():
	if samples.size() > 0:
		var rand_index = randi() % samples.size()
		stream = samples[rand_index]

func play(from_position : float = 0.0):
	choose_random()
	.play(from_position)
