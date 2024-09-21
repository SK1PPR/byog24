extends Node

@export var innerRadius: float
@export var outerRadius: float

@export var enemies: Array[Resource]

@onready var player := $"../player"
@onready var timer := $Timer

signal wave_ended()

class Wave:
	var totalEnemies: int
	var enemyNumbers: Array[int]
	var avgSpawnRate: float
	
	func _init(nums: Array[int], spawnRate: float) -> void:
		enemyNumbers = nums
		totalEnemies = nums.size()
		avgSpawnRate = spawnRate
		
var currentWave: int
var waves: Array[Wave]

# For _on_timer_timeout_function
var cur_ind: int
var enemyOrder: Array[Resource]
var currentWaitTime: float

# For keeping track of number of enemies killed to mark end of waves
var enemiesDead: int
		
func _ready() -> void:
	# Sorry Hardcode :(
	waves.append(Wave.new([10, 0, 0, 0], 1)) # Wave 1
	waves.append(Wave.new([5, 5, 5, 5], 2)) # Wave 2
	waves.append(Wave.new([10, 0, 0, 0], 3)) # Wave 3
	waves.append(Wave.new([10, 0, 0, 0], 4)) # Wave 4
	waves.append(Wave.new([10, 0, 0, 0], 5)) # Wave 5
	
func get_random_wait_time(avgWaitTime: float) -> float:
	return randf_range(0.7 * avgWaitTime, 1.3 * avgWaitTime)

func get_random_spawn_cords() -> Vector2:
	var random_r := randf_range(innerRadius, outerRadius)
	var random_theta := randf_range(0, 2 * PI)
	var pos: Vector2 = player.position
	var x := pos[0] + random_r * cos(random_theta)
	var y := pos[1] + random_r * sin(random_theta)
	return Vector2(x, y)

func start_wave(waveNum: int):
	var avgWaitTime := 1 / waves[waveNum].avgSpawnRate
	var curWave: Wave = waves[waveNum]
	var enemyOrderTemp: Array[Resource]
	for i in range(curWave.enemyNumbers.size()):
		for j in range(curWave.enemyNumbers[i]):
			enemyOrderTemp.append(enemies[i]);
	enemyOrderTemp.shuffle()
	enemyOrder = enemyOrderTemp
	cur_ind = 0
	currentWaitTime = avgWaitTime
	#print(enemyOrder.size())
	enemiesDead = 0
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	if cur_ind < enemyOrder.size():
		#print("New enemy spawned aaaaaahhhhhh")
		var newEnemy = enemyOrder[cur_ind].instantiate()
		newEnemy.global_position = get_random_spawn_cords()
		get_parent().add_child(newEnemy)
		timer.wait_time = get_random_wait_time(currentWaitTime)
		timer.start()
		cur_ind += 1
		
func _on_mob_death() -> void:
	enemiesDead += 1
	if enemiesDead >= enemyOrder.size():
		enemiesDead = 0
		emit_signal("wave_ended")
