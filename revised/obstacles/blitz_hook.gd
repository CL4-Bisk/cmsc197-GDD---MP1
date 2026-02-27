extends Unique
class_name BlitzHook

@export var hand : PackedScene
@export var pull_power := 800.0
var f : Node2D

func randomize_firing_position(l: float, r: float, g: float, s: float) -> void:
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
	anim.play("warn", -1, speed_scale)
	$Warn.play()
	await anim.animation_finished
	get_tree().current_scene.add_child(f)
	print(f.global_position.y)
	f.show()
	f.notif.screen_exited.connect(func(): finished.emit())

func pull() -> void:
	var dir = (global_position - bird.global_position).normalized()
	bird.bird_condition = Bird.BirdStatus.HOOKED
	bird.hitbox.set_deferred("set_disabled", true)
	bird.gravity = 0
	bird.collision_layer = 0
	bird.velocity = dir * pull_power
