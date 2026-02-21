extends Node
class_name Main

@onready var screensize := get_viewport().get_visible_rect().size
@onready var bird: Bird = $Bird
@onready var pipe_spawner: PipeSpawner = $PipeSpawner
var score := 0

func _ready() -> void:
	bird.position = screensize/2

func game_start() -> void:
	pipe_spawner.start_spawner()

func score_point() -> void:
	score += 1
	print(score)
