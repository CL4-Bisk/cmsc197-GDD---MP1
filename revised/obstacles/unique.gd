@abstract
extends Area2D
class_name Unique

signal bird_hit
signal finished

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var warning_duration := 1.0

@export_category("Obstacle Values")
@export var is_lethal := false
@export var damage_amount := 0.0
@export var stun_duration := 0.0

var speed_scale := 1.0

func _ready() -> void:
	hide()
	var d = anim.get_animation("warn").length
	speed_scale = d / warning_duration
	body_entered.connect(hit)

@abstract func randomize_firing_position(left: Marker2D, right: Marker2D, ground: Marker2D) -> void

@abstract func fire() -> void

func hit(body: Node2D) -> void:
	bird_hit.emit(is_lethal, damage_amount, stun_duration)
