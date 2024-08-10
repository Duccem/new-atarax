extends CharacterBody2D

var SPEED = 20
var player_chase = false
var player = null

var health = 100
var player_in_attack_range = false

func _physics_process(delta):
	take_damage()
	if player_chase:
		position += (player.position - position).normalized() * SPEED * delta
		$AnimatedSprite2D.flip_h = player.position.x < position.x
		$AnimatedSprite2D.play("move_front")
		move_and_collide(Vector2(0,0))
	else: 
		$AnimatedSprite2D.play("idle_front")
func _on_detection_area_body_entered(body:Node2D):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body:Node2D):
	player = null
	player_chase = false

func enemy():
	pass


func _on_hitbox_body_entered(body:Node2D):
	if body.has_method("player"):
		player_in_attack_range = true


func _on_hitbox_body_exited(body:Node2D):
	if body.has_method("player"):
		player_in_attack_range = false

func take_damage():
	if player_in_attack_range and GameManager.player_current_attack:
		health -= 20
		if health <= 0:
			self.queue_free()
