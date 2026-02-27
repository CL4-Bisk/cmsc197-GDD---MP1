extends Unique
class_name LuxLaser

func randomize_firing_position(_l: float, _r: float, g: float, s: float) -> void:
	global_position.y = randf_range(g, s + 50)

func fire() -> void:
	show()
	anim.play("warn", -1, speed_scale)
	$Warn.play()
	anim.queue("fire")
	await anim.animation_finished
	$Fire.play()
	finished.emit()
	await anim.animation_finished
	call_deferred("hide")
