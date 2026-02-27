@abstract
extends Area2D
class_name Unique

signal bird_hit
signal finished

@onready var hitbox: CollisionShape2D = $Hitbox
@export var warning_duration := 1.0

@export_category("Obstacle Values")
@export var is_lethal := false
@export var damage_amount := 0.0
@export var stun_duration := 0.0

var bird : Bird = null

func _ready() -> void:
	hide()
	body_entered.connect(hit)

@abstract func randomize_firing_position(l: float, r: float, g: float, s: float) -> void

@abstract func fire() -> void

func parse(birdie : Node2D) -> void:
	bird = birdie

func hit(_body: Node2D) -> void:
	if not _body is Bird: return
	bird_hit.emit(is_lethal, damage_amount, stun_duration)
	$Hit.play()
