extends Node
class_name PipeSpawner

signal bird_crashed
signal score_point

var pipe_scene = preload("res://revised/pipe.tscn")
@export_range(0, 1000) var pipe_speed = 150
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_pipe)

func start_spawner() -> void:
	spawn_timer.start()

func spawn_pipe() -> void:
	var pipe = pipe_scene.instantiate() as Pipe
	add_child(pipe)
	
	var viewport_rect = get_viewport().get_visible_rect()
	
	pipe.position.x = viewport_rect.end.x + 200
	
	var half_height = viewport_rect.size.y / 2
	pipe.position.y = randf_range(
		0 + (0.4 * half_height), 
		viewport_rect.size.y - (0.4 * half_height))
	
	pipe.bird_crashed.connect(stop)
	pipe.score_point.connect(func(): score_point.emit())
	pipe.set_speed(pipe_speed)

func stop():
	bird_crashed.emit()
	spawn_timer.stop()
	for pipe in get_children().filter(func(child): return child is Pipe):
		(pipe as Pipe).set_speed(0)
