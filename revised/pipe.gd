extends Node2D
class_name Pipe

signal bird_crashed
signal score_point

var _speed = 0

func set_speed(value : float) -> void:
	_speed = value

func _process(delta: float) -> void:
	position.x += -_speed * delta

func _pipe_hit(body: Node2D) -> void:
	bird_crashed.emit()

func _pipe_passed(body: Node2D) -> void:
	score_point.emit()

func _on_screen_exited() -> void:
	queue_free()
