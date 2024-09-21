extends Node2D  # Adjust based on your node structure

@onready var particles = $CPUParticles2D  # Reference to your CPUParticles2D node

func _ready():
	particles.emitting = false  # Ensure it's not emitting initially
	play_blood_splatter()

func play_blood_splatter():
	particles.emitting = true  # Start emitting particles

	# Start a timer to handle fading and stopping
	await get_tree().create_timer(0.1).timeout  # Initial wait for particles to emit

	# Gradually reduce opacity
	var fade_duration = 1.0  # Duration for the fade effect
	var steps = 10  # Number of steps for fading
	var step_time = fade_duration / steps  # Time per step
	var alpha_step = 1.0 / steps  # Amount to decrease alpha per step

	for i in range(steps):
		await get_tree().create_timer(step_time).timeout  # Wait for each step
		particles.modulate.a -= alpha_step  # Reduce opacity

	# Ensure opacity is set to 0 before stopping emission
	particles.modulate.a = 0
	particles.emitting = false  # Stop emitting particles
	queue_free()
