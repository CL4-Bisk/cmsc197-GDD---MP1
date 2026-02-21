extends CharacterBody2D
class_name Bird

signal start_game

@export var gravity := 900.0
@export var jump_force := 300.0
@export var max_fall_speed := 400.0
@export var rotation_speed := 2

var game_started := false
var take_input := true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	velocity = Vector2.ZERO
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") && take_input:
		if !game_started:
			game_started = true
			start_game.emit()
		jump()
	
	if !game_started: return
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	
	move_and_collide(delta * velocity)
	
	## for other mechanics
	#move_and_slide()
	#if is_on_floor():
		#print("Grounded!")
	rotate_bird()

func jump() -> void:
	sprite.stop()
	velocity.y = -jump_force
	sprite.play("fly")
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(-30), 0.05)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

func rotate_bird() -> void:
	if velocity.y > 0 && rad_to_deg(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func stop() -> void:
	take_input = false
	gravity = 0
	velocity = Vector2.ZERO
	sprite.play("die")
