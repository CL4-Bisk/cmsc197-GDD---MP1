extends CharacterBody2D
class_name Bird

signal start_game
signal bird_ded
signal health_changed

@export_category("Bird Values")
@export var health_max := 100
@export var gravity_power := 1200.0
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
var touching_floor
var level := 0
var xp := 0
var xp_per_level := 10
var gravity := 0.0
var bird_condition : BirdStatus
enum BirdStatus {
	IDLE,
	NORMAL,
	STUNNED,
	HOOKED,
	DEAD
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_timer: Timer = $StunTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var s_ind: Sprite2D = $StunIndicator
@onready var exp_timer: Timer = $ExpTimer
@onready var hitbox: CollisionShape2D = $Hitbox

func _ready() -> void:
	stun_timer.timeout.connect(can_move)
	exp_timer.timeout.connect(gain_exp)
	reset()
	
func can_move() -> void:
	if !is_alive: return
	bird_condition = BirdStatus.NORMAL
	s_ind.modulate.a = 1.0
	s_ind.create_tween().tween_property(s_ind, "scale", s_ind.scale * 0.5, 0.1)
	s_ind.create_tween().tween_property(s_ind, "modulate:a", 0.0, 0.2)

func reset() -> void:
	bird_condition = BirdStatus.IDLE
	collision_layer = 1
	s_ind.show()
	level = 1
	xp = 0
	xp_per_level = 10
	health_max = 100
	health = health_max
	is_alive = true
	velocity = Vector2.ZERO
	position = screensize/2
	sprite.play("idle")
	hitbox.call_deferred("set_disabled", false)
	gravity = gravity_power

func game_start() -> void:
	bird_condition = BirdStatus.NORMAL
	gravity = gravity_power
	sprite.stop()
	exp_timer.start()
	start_game.emit()

func _physics_process(delta: float) -> void:
	global_position.y = clamp(global_position.y, 0, screensize.y)
	global_position.x = clamp(global_position.x, -100, screensize.x + 200)
	
	match bird_condition:
		BirdStatus.HOOKED:
			move_and_slide()
		BirdStatus.IDLE, BirdStatus.NORMAL:
			if Input.is_action_just_pressed("jump"):
				flap()
			
			if bird_condition == BirdStatus.NORMAL:
				velocity.y += gravity * delta
				move_and_slide()
				rotate_bird()
			velocity.y = min(velocity.y, max_fall_speed)
			
		BirdStatus.STUNNED:
			velocity.y += gravity * delta
			move_and_slide()
		BirdStatus.DEAD:
			return
	if bird_condition != BirdStatus.DEAD:
		health = clamp(health + (0.3 * delta), 0, health_max)
	
	if is_on_floor():
		velocity.x = 0
		if !touching_floor:
			touching_floor = true
			anim.stop()
			flop()
	else:
		if bird_condition != BirdStatus.HOOKED:
			velocity.x = move_toward(velocity.x, wind_power, air_friction)
		touching_floor = false

func gain_exp() -> void:
	xp += 1
	if xp >= xp_per_level:
		level = min(level + 1, 18)
		xp = 0
		xp_per_level += (5 * level)
		$LevelUp.play()
		exp_timer.start()
		health_max += 10
		health += 10
	if level >= 18: 
		exp_timer.stop()

func flap() -> void:
	anim.stop()
	anim.play("flap")
	velocity = Vector2(forward_power, -jump_force)
	$Flap.play(0.03)
	var t = create_tween()
	t.tween_property(self, "rotation", deg_to_rad(-30), 0.05)
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_OUT)

func rotate_bird() -> void:
	if velocity.y > 0 && rad_to_deg(rotation) < 45:
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func stun(duration : float) -> void:
	if !is_alive: return
	bird_condition = BirdStatus.STUNNED
	flop()
	
	s_ind.show()
	s_ind.scale = Vector2(0.5, 0.5)
	s_ind.modulate.a = 1.0
	s_ind.create_tween().set_loops().tween_property(s_ind, "rotation", 15, 3).as_relative()
	
	stun_timer.stop()
	stun_timer.start(duration)

func damage(value : float) -> void:
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
	if is_alive:
		anim.play("flop")
	else:
		anim.play("dead")
		gravity = 0
	rotation = 0

func stop() -> void:
	if !is_alive : return
	bird_condition = BirdStatus.DEAD
	is_alive = false
	s_ind.hide()
	exp_timer.stop()
	stun_timer.stop()
	$Ded.play()
	anim.play("die")
	rotation = 0
	velocity = Vector2.ZERO
	await anim.animation_finished
	health = 0
	bird_ded.emit() 
	get_tree().create_tween().kill()

func _on_exit() -> void:
	stop()
