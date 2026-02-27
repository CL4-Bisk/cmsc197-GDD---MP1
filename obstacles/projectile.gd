extends CollisionObject2D
class_name Projectile

signal bird_hit
@export var speed := 200.0
@export var spawn_location : SpawnPositions
enum SpawnPositions {
	LEFT_SIDE,
	RIGHT_SIDE,
	AERIAL,
	GROUND
}
@export var delete_on_collide := false
@export var chase_bird := false
@export var chase_duration = 0.0

@export var aim_to_bird := false
@export var damage_amount := 10.0
@export var is_lethal := false
@export var stun_duration := 0.0

@onready var notif: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var move_dir: Vector2
var bird = null

func set_speed(val : float) -> void:
	speed = val

func _ready() -> void:
	$Fire.play()
	$Texture.speed_scale = randf_range(0.9, 1.1)
	
	if chase_duration > 0:
		var t = Timer.new()
		add_child(t)
		t.start(chase_duration)
		t.timeout.connect(func f(): chase_bird = false)
	
	if aim_to_bird and bird:
		move_dir = global_position.direction_to(bird.global_position)
		look_at(bird.global_position)

func _process(delta: float) -> void:
	if chase_bird and bird:
		if bird.is_alive: 
			move_dir = global_position.direction_to(bird.global_position)
			look_at(bird.global_position)
	global_position += move_dir * speed * delta

func setup_projectile(birdie : Node2D, l: float, r: float, g: float, s: float, spd: float) -> void:
	bird = birdie
	match spawn_location:
		SpawnPositions.LEFT_SIDE, SpawnPositions.RIGHT_SIDE:
			global_position.y = randf_range(s, g)
			if spawn_location == SpawnPositions.LEFT_SIDE:
				global_position.x = l
				move_dir = Vector2.RIGHT
			else:
				global_position.x = r
				move_dir = Vector2.LEFT
		SpawnPositions.AERIAL:
			global_position.x = randf_range(l, r)
			global_position.y = s
			move_dir = Vector2.DOWN
		SpawnPositions.GROUND:
			global_position = Vector2(r, g)
			move_dir = Vector2.LEFT
			speed = spd

	if !chase_bird: 
		$Texture.flip_h = (move_dir == Vector2.LEFT)

func _hit(_body: Node2D) -> void:
	if _body.collision_layer != 1: return
	if _body is Bird and (_body as Bird).bird_condition == Bird.BirdStatus.DEAD: return
	$Hit.play()
	bird_hit.emit(is_lethal, damage_amount, stun_duration)
	chase_bird = false
	
	if delete_on_collide:
		$Texture.visible = false
		$Hitbox.call_deferred("set_disabled", true)
		await $Hit.finished
		queue_free()

func _on_exit() -> void:
	queue_free()
