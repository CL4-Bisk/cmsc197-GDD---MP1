extends Unique
class_name LuxLaser

func randomize_firing_position(left: Marker2D, right: Marker2D, ground: Marker2D) -> void:
	global_position.y = randi_range(ground.global_position.y, left.global_position.y)

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
