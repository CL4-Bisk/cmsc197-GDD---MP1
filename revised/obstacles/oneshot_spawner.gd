extends Node
class_name OneShotSpawner

signal bird_kill

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ammunitions: Array = $Ammunitions.get_children() as Array[OneShot]

@export var delay := 5.0
var kinds := 0
var game_started := false

func _ready() -> void:
	spawn_timer.timeout.connect(ready_fire)
	kinds = len(ammunitions)

func start() -> void:
	spawn_timer.start(10)
	game_started = true

func ready_fire() -> void:
	if !game_started: return
	var r = randi_range(0, kinds - 1)
	var k = ammunitions.get(r)
	k.global_position.y = randi_range($SkyR.position.y, $GroundR.position.y)
	k.spawn_hitter()
	await k.finish_fire
	if game_started: 
		spawn_timer.start(randf_range(delay, delay + randf_range(0, 8)))

func stop() -> void:
	spawn_timer.stop()
	game_started = false

func bird_hit() -> void:
	bird_kill.emit()
