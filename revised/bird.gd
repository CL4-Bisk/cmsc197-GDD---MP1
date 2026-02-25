extends CharacterBody2D
class_name Bird

signal start_game
signal bird_ded
signal health_changed()

@export_category("Bird Values")
@export var health_max := 100
@export var gravity := 1200
@export var jump_force := 275.0
@export var forward_power := 200

@export_category("Environment")
@export var wind_power := -50.0
@export var air_friction = 15.0
@export var max_fall_speed := 400.0
@export var rotation_speed := 2

var screensize := Vector2.ZERO
var health
var is_alive := true
var game_started := false
var take_input := true
var touching_floor

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_timer: Timer = $StunTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var s_ind: Sprite2D = $StunIndicator


func _ready() -> void:
	stun_timer.timeout.connect(can_move)
	reset()
	
func can_move() -> void:
	take_input = true
	var t = create_tween()
	t.tween_property(s_ind, "scale", s_ind.scale * 0.9, 0.1)
	t.tween_property(s_ind, "modulate:a", 0.0, 0.1)

func reset() -> void:
	health = health_max
	is_alive = true
	game_started = false
	velocity = Vector2.ZERO
	position = screensize/2
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if !is_alive: return
	
	if Input.is_action_just_pressed("jump") && take_input:
		if !game_started:
			game_started = true
			sprite.stop()
			start_game.emit()
		flap()
	
	if !game_started: return
	
	health = clamp(health + (0.8 * delta), 0, health_max)
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	
	global_position.y = clamp(global_position.y, 0, screensize.y)
	
	if is_on_floor():
		velocity.x = 0
		if !touching_floor:
			touching_floor = true
			anim.stop()
			flop()
	else:
		touching_floor = false
		velocity.x = move_toward(velocity.x, wind_power, air_friction)
	
	move_and_slide()
	rotate_bird()

func flap() -> void:
	anim.stop()
	anim.play("flap")
	velocity.y = -jump_force
	velocity.x = forward_power
	$Flap.play(0.03)
	var tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(-30), 0.05)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

func rotate_bird() -> void:
	if velocity.y > 0 && rad_to_deg(rotation) < 45:
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func stun(duration : float) -> void:
	if !is_alive: return
	take_input = false
	
	s_ind.scale = Vector2(0.5, 0.5)
	s_ind.modulate.a = 1.0
	
	var t = create_tween().set_loops()
	t.tween_property(s_ind, "rotation", 15, 3).as_relative()
	
	stun_timer.stop()
	stun_timer.start(duration)
	flop()

func change_health(value : float) -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.DIM_GRAY, 0.05)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	health = clamp(health - value, 0, health_max)
	health_changed.emit(health, health_max)
	
	if health <= 0:
		stop()

func flop() -> void:
	if anim.current_animation == "flop":
		return
	anim.stop()
	anim.play("flop")
	rotation = 0

func stop() -> void:
	health = 0
	take_input = false
	is_alive = false
	
	$CollisionShape2D.set_deferred("disabled", true)
	gravity = 0
	velocity = Vector2.ZERO
	
	bird_ded.emit()
	sprite.play("die")
	rotation = 0

func _on_exit() -> void:
	change_health(health_max)
