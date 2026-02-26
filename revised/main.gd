extends Node
class_name Main

@onready var screensize := get_viewport().get_visible_rect().size
@onready var bird: Bird = $Bird
@onready var p_spawner: CommonSpawner = $CommonSpawner
@onready var o_spawner: UniqueSpawner = $UniqueSpawner
@onready var ground: Ground = $Ground

@onready var gold_gain: Timer = $GoldGain
@onready var gold_counter: Label = $GoldCounter
@onready var progress_bar: ProgressBar = $ProgressBar

@export var scroll_speed := 100.0
@onready var background: Parallax2D = $Background

var gold = 0
var score := 0

func _ready() -> void:
	bird.position = screensize/2
	bird.screensize = screensize
	
	ground.speed = -scroll_speed
	
	p_spawner.parse(bird)
	o_spawner.parse(bird)
	
	p_spawner.bird_hit.connect(bird_hit)
	o_spawner.bird_hit.connect(bird_hit)
	
	gold_gain.timeout.connect(gain_gold)

func game_start() -> void:
	progress_bar.show()
	p_spawner.start()
	o_spawner.start()
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

func bird_hit(is_lethal : bool, damage_amount : float = 0, stun_duration : float = 0):
	if is_lethal:
		bird.stop()
	if damage_amount > 0:
		bird.change_health(damage_amount)
	if stun_duration > 0: 
		bird.stun(stun_duration)
