extends Node
class_name UniqueSpawner

signal bird_hit

var bird = null

@onready var spawn_timer: Timer = $SpawnTimer
@onready var unique_spells: Array = $Ammunitions.get_children() as Array[Unique]
@onready var right: Marker2D = $Right
@onready var ground: Marker2D = $Ground
@onready var left: Marker2D = $Left

@export var delay := 5.0

var kinds := 0
var game_started := false

func _ready() -> void:
	spawn_timer.timeout.connect(spell_prep)

func start() -> void:
	spawn_timer.start(10)
	game_started = true

func parse(birdie : Node2D) -> void:
	bird = birdie

func spell_prep() -> void:
	if !game_started: return
	var r = randi_range(0, len(unique_spells) - 1)
	var spell = unique_spells.get(r) as Unique
	
	spell.randomize_firing_position(left, right, ground)
	spell.bird_hit.connect(func(x, y, z): bird_hit.emit(x, y, z))
	spell.fire()
	await spell.finished
	if game_started: 
		spawn_timer.start(randf_range(delay, delay + randf_range(0, 8)))

func stop() -> void:
	spawn_timer.stop()
	game_started = false
