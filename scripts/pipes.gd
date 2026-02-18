extends Area2D

var speed: int = 150

func _process(delta: float) -> void:
	position.x -= speed * delta
