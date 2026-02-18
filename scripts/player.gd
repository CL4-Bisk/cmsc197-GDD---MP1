extends Area2D

signal pickup
signal hurt

@export var blast_scene: PackedScene

var velocity = Vector2.ZERO
const GRAVITY = 1200.0
const JUMP_FORCE = -400.0
var screensize: Vector2 = Vector2(720, 480)
var hearts_list: Array[TextureRect]
var health: int = 5

var current_state: Enums.PlayerState = Enums.PlayerState.IDLE

func _process(delta):
	# Apply gravity to your custom velocity variable
	
	velocity.y += GRAVITY * delta
	
	# Handle Flap
	if Input.is_action_just_pressed("flap"):
		current_state = Enums.PlayerState.FLYING
		velocity.y = JUMP_FORCE
	elif Input.is_action_just_pressed("ui_fire_blast"):
		current_state = Enums.PlayerState.ATTACK
		fire_blast()
		
	# Manually update the position
	position += velocity * delta
	position.y = clamp(position.y, 0, screensize.y)
	
	if position.y <= 0 or position.y >= screensize.y:
		current_state = Enums.PlayerState.HURT
	
	match current_state:
		Enums.PlayerState.IDLE:
			$AnimatedSprite2D.animation = "idle"
		Enums.PlayerState.ATTACK:
			$AnimatedSprite2D.animation = "attack"
			$AnimatedSprite2D.animation_finished
		Enums.PlayerState.HURT:
			$AnimatedSprite2D.animation = "hurt"
		Enums.PlayerState.DIE:
			$AnimatedSprite2D.animation = "die"
		Enums.PlayerState.FLYING:
			$AnimatedSprite2D.animation = "flying"

func fire_blast():
	if blast_scene:
		var blast = blast_scene.instantiate()
		get_parent().add_child(blast)
		blast.position = self.position

func start() -> void:
	set_process(true)
	position = screensize / 8
	$AnimatedSprite2D.animation = "idle"

func die() -> void:
	$AnimatedSprite2D.animation = "die"
	set_process(false)

#use for pickups
#func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("coins"):
		#area.pickup()
		#pickup.emit("coin")
	#if area.is_in_group("powerups"):
		#area.pickup()
		#pickup.emit("powerup")
	#if area.is_in_group("obstacles"):
		#hurt.emit()
		#die()
