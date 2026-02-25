extends Area2D
class_name Projectile

signal bird_hurt
signal bird_stun

@export var speed := 200.0
@export var delete_on_collide := false
@export var damage_amount := 10.0
@export var stun_duration := 0.0

func _ready() -> void:
	$Fire.play()
	speed = randf_range(speed * 0.9, speed * 1.1)

func _process(delta: float) -> void:
	position.x -= speed * delta

func _hit(body: Node2D) -> void:
	$Hit.play()
	if damage_amount > 0:
		bird_hurt.emit(damage_amount)

	if stun_duration > 0:
		bird_stun.emit(stun_duration)
	
	if delete_on_collide:
		$Texture.visible = false
		await $Hit.finished
		queue_free()

func _on_exit() -> void:
	queue_free()
