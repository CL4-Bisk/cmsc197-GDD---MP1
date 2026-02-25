extends Area2D
class_name OneShot

signal bird_kill
signal finish_fire

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var warning_duration := 1.0
var speed_scale := 1.0

func _ready() -> void:
	hide()
	var d = anim.get_animation("warn").length
	speed_scale = d / warning_duration

func spawn_hitter() -> void:
	show()
	anim.play("warn", -1, speed_scale)
	$Warn.play()
	anim.queue("fire")
	await anim.animation_finished
	$Fire.play()
	finish_fire.emit()
	await anim.animation_finished
	call_deferred("hide")

func _hit(body : Node2D) -> void:
	bird_kill.emit()
