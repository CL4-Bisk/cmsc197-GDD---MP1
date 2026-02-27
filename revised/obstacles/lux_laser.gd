extends Unique
class_name LuxLaser

func randomize_firing_position(_l: float, _r: float, g: float, s: float) -> void:
	global_position.y = randf_range(g, s + 50)

func fire() -> void:
	show()
	$Ping.modulate.a = 1.0
	$Ping.scale = Vector2(0.2, 0.2)
	create_tween().tween_property($Ping, "modulate:a", 0, warning_duration).set_ease(Tween.EASE_OUT)
	create_tween().tween_property($Ping, "scale", Vector2(0.5, 0.5), warning_duration).set_ease(Tween.EASE_OUT)
	
	$Timer.start(warning_duration)
	$AnimationPlayer.play("warn")
	$Warn.play()
	await $Timer.timeout
	$Fire.play()
	$AnimationPlayer.play("fire")
	finished.emit()
	await $AnimationPlayer.animation_finished
	call_deferred("hide")
