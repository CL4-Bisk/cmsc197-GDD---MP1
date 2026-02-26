extends Area2D
class_name Projectile

signal bird_hit
@export var speed := 200.0
@export var spawn_location : SpawnPositions
enum SpawnPositions {
	LEFT_SIDE,
	RIGHT_SIDE,
	AERIAL
}
@export var delete_on_collide := false
@export var chase_bird := false
@export var chase_duration = 0.0

@export var aim_to_bird := false
@export var damage_amount := 10.0
@export var stun_duration := 0.0

var move_dir: Vector2
var bird = null

func _ready() -> void:
	$Fire.play()
	$Texture.speed_scale = randf_range(0.9, 1.1)
	speed = randf_range(speed * 0.9, speed * 1.1)
	
	if chase_duration > 0:
		var t = Timer.new()
		add_child(t)
		t.start(chase_duration)
		t.timeout.connect(func f(): chase_bird = false)
	
	if aim_to_bird and bird:
		move_dir = global_position.direction_to(bird.global_position)
		look_at(bird.global_position)
	else:
		if !chase_bird: 
			$Texture.flip_h = (spawn_location == SpawnPositions.RIGHT_SIDE)

func _process(delta: float) -> void:
	if chase_bird and bird:
		move_dir = global_position.direction_to(bird.global_position)
		look_at(bird.global_position)
	
	global_position += move_dir * speed * delta

func setup_projectile(birdie : Node2D, left : Marker2D, right : Marker2D, ground : Marker2D) -> void:
	bird = birdie
	match spawn_location:
		SpawnPositions.LEFT_SIDE, SpawnPositions.RIGHT_SIDE:
			global_position.y = randf_range(left.global_position.y, ground.global_position.y)
			if spawn_location == SpawnPositions.LEFT_SIDE:
				global_position.x = left.global_position.x
				move_dir = Vector2.RIGHT
			else:
				global_position.x = right.global_position.x
				move_dir = Vector2.LEFT
		SpawnPositions.AERIAL:
			global_position.x = randf_range(left.global_position.x, right.global_position.x)
			global_position.y = right.global_position.y
			move_dir = Vector2.DOWN

func _hit(body: Node2D) -> void:
	$Hit.play()
	bird_hit.emit(false, damage_amount, stun_duration)
	chase_bird = false
	
	if delete_on_collide:
		$Texture.visible = false
		await $Hit.finished
		queue_free()

func _on_exit() -> void:
	queue_free()
