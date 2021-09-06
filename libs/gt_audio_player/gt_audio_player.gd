extends AudioStreamPlayer
class_name GTAudioPlayer

export (Array, AudioStream) var samples
export (float) var random_pitch_deviation = 0.0

onready var initial_pitch = pitch_scale

func choose_random():
	if samples.size() > 0:
		var rand_index = randi() % samples.size()
		stream = samples[rand_index]

func rand_pitch():
	pitch_scale = initial_pitch + (2*randf()-1.0)*random_pitch_deviation

func play(from_position: float = 0.0):
	if samples.size() > 0:
		choose_random()
	if random_pitch_deviation != 0.0:
		rand_pitch()
	.play(from_position)
