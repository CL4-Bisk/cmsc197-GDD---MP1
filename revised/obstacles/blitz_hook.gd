extends Unique
class_name BlitzHook

@export var hand : PackedScene
@export var pull_power := 800.0
@onready var trail: Line2D = $trail
var f : Node2D
var grabbed : Node2D

func _process(delta: float) -> void:
	if f and f.visible:
		trail.set_point_position(1, trail.to_local(grabbed.global_position))

func randomize_firing_position(l: float, r: float, g: float, s: float) -> void:
	trail.hide()
	trail.set_point_position(0, Vector2.ZERO)
	trail.set_point_position(1, Vector2.ZERO)
	global_position.y = randf_range(g, s)
	print(global_position.y)
	f = hand.instantiate() as Projectile
	f.setup_projectile(bird, l, r, global_position.y, global_position.y, 0)
	f.hide()
	f.bird_hit.connect(func(x, y, z): 
		bird_hit.emit(x, y, z) 
		pull())

func fire() -> void:
	show()
	$Timer.start(warning_duration)
	grabbed = f
	trail.show()
	$Warn.play()
	$Ping.modulate.a = 1.0
	$Ping.scale = Vector2(0.2, 0.2)
	create_tween().tween_property($Ping, "modulate:a", 0, warning_duration).set_ease(Tween.EASE_OUT)
	create_tween().tween_property($Ping, "scale", Vector2(0.5, 0.5), warning_duration).set_ease(Tween.EASE_OUT)

	await $Timer.timeout
	get_tree().current_scene.add_child(f)
	print(f.global_position.y)
	f.show()
	f.notif.screen_exited.connect(
		func(): 
			finished.emit()
			trail.hide())

func pull() -> void:
	var dir = (global_position - bird.global_position).normalized()
	grabbed = bird
	bird.bird_condition = Bird.BirdStatus.HOOKED
	bird.hitbox.set_deferred("set_disabled", true)
	bird.gravity = 0
	bird.collision_mask = 0
	bird.collision_layer = 0
	bird.velocity = dir * pull_power
