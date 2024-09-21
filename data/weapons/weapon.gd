class_name Weapon
extends Area2D

@export var weapons_stats: WeaponStats
@export var bullet: PackedScene
@export var fired_bullets: int
@export var fire_point_nodes: Array[NodePath]
@export var range_area: CollisionShape2D
@export var interval: float

var timer
var gap_timer
var count:int = 0
var can_fire: bool = false
var fire_points: Array[Marker2D] = []
#@onready var audioPlayer = get_node("GunshotAudio")

func _ready():
	# timer for fire rate
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "_fire_timer_out"))
	timer.start(weapons_stats.fire_rate)
	for path in fire_point_nodes :
		var fire_point = get_node(path)
		fire_points.append(fire_point)
	print("Fire points count:", fire_points.size())
	
	range_area.shape.radius = weapons_stats.range
	
func _fire_timer_out():
	can_fire = true

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		if can_fire:
			fire()
	if global_rotation_degrees < -90 or global_rotation_degrees > 90:
		%Gun.flip_v = true
		#%Gun2.flip_v = true
	else:
		%Gun.flip_v = false
		#%Gun2.flip_v = false
			
func fire():
	for fire_point in fire_points:
		var i = fired_bullets
		while i > 0 :
			var projectile = bullet.instantiate()
			projectile.global_position = fire_point.global_position
			projectile.global_rotation = fire_point.global_rotation + randf_range(-weapons_stats.spread, weapons_stats.spread)
			get_tree().current_scene.add_child(projectile)
			count += 1
			i -= 1

	can_fire = false
	timer.start(weapons_stats.fire_rate)
	
