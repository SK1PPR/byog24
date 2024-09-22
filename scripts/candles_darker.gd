extends Node2D

@export var noise: NoiseTexture2D
var time_passed := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)*20
	$".".energy = sampled_noise
