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
@onready var yuumi: Sprite2D = $Yuumi

@export var scroll_speed := 100.0
@onready var background: Parallax2D = $Background
@onready var ui: Control = $UI

var gold = 0
var score := 0
var start: bool = false
var is_game_over: bool = false

func _ready() -> void:
	bird.position = screensize/2
	bird.screensize = screensize
	
	if start == false:
		ui.show()
	
	ground.speed = -scroll_speed
	
	p_spawner.parse(bird, scroll_speed)
	o_spawner.parse(bird)
	
	p_spawner.bird_hit.connect(bird_hit)
	o_spawner.bird_hit.connect(bird_hit)
	
	gold_gain.timeout.connect(gain_gold)

func game_start() -> void:
	ui.hide()
	yuumi.show()
	progress_bar.show()
	p_spawner.start()
	o_spawner.start()
	gold_gain.start()

func gain_gold() -> void:
	gold += randi_range(2, 4)
	gold_counter.text = str(gold)
	gold_gain.start()

func _process(delta: float) -> void:
	# RESTART LOGIC
	if is_game_over and Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene() # Wipes everything and starts fresh
		return # Stop processing the rest of this frame

	# START LOGIC
	if not start and not is_game_over and Input.is_action_just_pressed("ui_accept"):
		start = true
		game_start()

	progress_bar.value = bird.health
	progress_bar.max_value = bird.health_max

func game_over() -> void:
	gold_gain.stop()
	background.autoscroll.x = 0
	ui.show() # Show the "Press Space to Start" menu again
	is_game_over = true
	start = false # Allow the start logic to trigger again

func bird_hit(is_lethal : bool, damage_amount : float = 0, stun_duration : float = 0):
	if is_lethal:
		bird.stop()
	if damage_amount > 0:
		bird.damage(damage_amount)
	if stun_duration > 0: 
		bird.stun(stun_duration)
