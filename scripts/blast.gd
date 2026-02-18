extends Area2D

@export var speed = 500

func _process(delta):
	# Move the blast across the screen
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Deletes the blast when it's off-screen
