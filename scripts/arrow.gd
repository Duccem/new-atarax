extends Area2D

func _process(delta):
	position += (Vector2.RIGHT * 100).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
