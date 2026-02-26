extends Node
class_name CommonSpawner

signal bird_hit

@export var projectiles : Array[PackedScene]
@export var max_spawn_interval := 3.0

@onready var right: float = $Right.global_position.x
@onready var ground: float = $Ground.global_position.y
@onready var left: float = $Left.global_position.x
@onready var sky: float = $Sky.global_position.y

@onready var spawn_timer: Timer = $SpawnTimer
var bird : Bird = null
var speed : float
var bird_level := 0

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_projectiles)

func parse(birdie : Node2D, scroll : float) -> void:
	bird = birdie
	speed = scroll

func start() -> void:
	spawn_timer.start()

func spawn_projectiles() -> void:
	var queued : Array[Projectile]
	for i in range(randi_range(1, 1 + bird.level)):
		var p = projectiles[
			randi_range(0, projectiles.size()-1)].instantiate() as Projectile
		p.setup_projectile(bird, left, right, ground, sky, speed)
		p.bird_hit.connect(func(x, y, z): bird_hit.emit(x, y, z))
		queued.append(p)
	
	spawn_timer.start(randf_range(0.05, max_spawn_interval))
	release_projectiles(queued)

func release_projectiles(p_list : Array[Projectile]) -> void:
	var timer = Timer.new()
	add_child(timer)
	for p in p_list:
		add_child(p)
		if p_list.size() > 1:
			timer.start(randf_range(0.2, 1.9))
			await timer.timeout
	timer.queue_free()

func game_stop() -> void:
	spawn_timer.stop()
	for timer in get_children().filter(func(f): return f != spawn_timer and f is Timer):
		(timer as Timer).stop()
		(timer as Timer).queue_free()
