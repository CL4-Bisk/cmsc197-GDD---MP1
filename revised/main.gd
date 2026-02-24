extends Node
class_name Main

@onready var screensize := get_viewport().get_visible_rect().size
@onready var bird: Bird = $Bird
@onready var spawner: ProjectileSpawner = $ProjectileSpawner
@onready var ground: Ground = $Ground

@onready var gold_gain: Timer = $GoldGain
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var gold_counter: Label = $GoldCounter

@export var scroll_speed := 100.0
@onready var background: Parallax2D = $Background

var gold = 0
var score := 0

func _ready() -> void:
	bird.position = screensize/2
	bird.screensize = screensize
	
	ground.speed = -scroll_speed
	
	spawner.bird_stunned.connect(bird.stun)
	spawner.bird_hurt.connect(bird.change_health)
	
	gold_gain.timeout.connect(gain_gold)

func game_start() -> void:
	progress_bar.show()
	spawner.start()
	gold_gain.start()

func gain_gold() -> void:
	gold += randi_range(2, 4)
	gold_counter.text = str(gold)
	gold_gain.start()

func _process(delta: float) -> void:
	progress_bar.value = bird.health
	progress_bar.max_value = bird.health_max

func game_over() -> void:
	gold_gain.stop()
	background.autoscroll.x = 0
