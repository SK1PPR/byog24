extends Camera2D

@export var playe_path: NodePath
@export var MIN_X = -2000
@export var MAX_X = 2000
@export var MIN_Y = -2000
@export var MAX_Y = 2000
var player

@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(playe_path)
	global_position = player.global_position
	#connect bullet signal
	RainMusic.bullet_shot.connect(Callable(self, "shake"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = player.global_position.x
	if global_position.x < MIN_X:
		global_position.x = MIN_X
	elif global_position.x > MAX_X:
		global_position.x = MAX_X
	global_position.y = player.global_position.y
	if global_position.y < MIN_Y:
		global_position.y = MIN_Y
	elif global_position.y > MAX_Y:
		global_position.y = MAX_Y
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0 , shake_fade * delta)
		
		offset = randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength, shake_strength))
	
func shake():
	shake_strength = random_strength
