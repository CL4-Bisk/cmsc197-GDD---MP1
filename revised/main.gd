extends Node
class_name Main

@onready var screensize := get_viewport().get_visible_rect().size
@onready var bird: Bird = $Bird
@onready var p_spawner: CommonSpawner = $CommonSpawner
@onready var o_spawner: UniqueSpawner = $UniqueSpawner
@onready var ground: Ground = $Ground

@onready var gold_gain: Timer = $GoldGain

@export var scroll_speed := 100.0
@onready var background: Parallax2D = $Background
@onready var ui: UIManager = $UI

var curr_state : GameState
enum GameState {
	TITLE,
	GAME,
	OVER
}
var gold := 0

func _ready() -> void:
	bird.position = screensize/2
	bird.screensize = screensize
	p_spawner.parse(bird, scroll_speed)
	o_spawner.parse(bird)
	p_spawner.bird_hit.connect(bird_hit)
	o_spawner.bird_hit.connect(bird_hit)
	gold_gain.timeout.connect(gain_gold)
	bird.bird_levelup.connect(func(): ui.update_level(bird.level))
	restart()

func game_start() -> void:
	curr_state = GameState.GAME
	ui.game_start()
	ui.update_health(bird.health, bird.health_max)
	ui.update_exp(bird.xp, bird.xp_per_level)
	p_spawner.start()
	o_spawner.start()
	gold_gain.start()

func game_over() -> void:
	curr_state = GameState.OVER
	gold_gain.stop()
	background.autoscroll.x = 0
	ui.game_over()

func restart() -> void:
	curr_state = GameState.TITLE
	ui.show_title()
	gold = 0
	background.autoscroll.x = -5
	ground.speed = -scroll_speed
	bird.reset()
	p_spawner.clean()

func gain_gold() -> void:
	gold += randi_range(2, 4)
	ui.update_gold(gold)
	gold_gain.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") && curr_state == GameState.OVER:
		restart()
	if Input.is_action_just_pressed("jump") && curr_state == GameState.TITLE:
		bird.game_start()
	ui.update_health(bird.health, bird.health_max)
	ui.update_exp(bird.xp, bird.xp_per_level)

func bird_hit(is_lethal : bool, damage_amount : float = 0, stun_duration : float = 0):
	if is_lethal:
		bird.stop()
	if damage_amount > 0:
		bird.damage(damage_amount)
	if stun_duration > 0: 
		bird.stun(stun_duration)
