extends AudioStreamPlayer
class_name GTAudioPlayer

export (Array, AudioStream) var samples
export (float) var random_pitch_deviation = 0.0

onready var initial_pitch = pitch_scale

# Selects a random sample from the 'samples' list
func choose_random_sample() -> void:
	if samples.size() > 0:
		var rand_index = randi() % samples.size()
		stream = samples[rand_index]

# Changes the pitch randomly, based on 'random_pitch_deviation'
func rand_pitch() -> void:
	pitch_scale = initial_pitch + (2*randf()-1.0)*random_pitch_deviation

# Chooses a random sample if 'samples' is not empty, changes the pitch randomly if random_pitch is not 0, and then plays the sample
func play(from_position: float = 0.0):
	if samples.size() > 0:
		choose_random_sample()
	if random_pitch_deviation != 0.0:
		rand_pitch()
	.play(from_position)
