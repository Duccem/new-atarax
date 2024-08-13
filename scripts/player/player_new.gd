extends CharacterBody2D


const SPEED = 100

var input_movement = Vector2.ZERO
@onready var animation_player = $animation_movment_player

var player_alive = true
var player_attacking = false
var player_knockbacked = false

func state_reset():
	player_attacking = false
	$Attacks.reset_state()

func _physics_process(_delta):
	if player_alive:
		player_movement()
	else:
		GameManager.reset_game()

func player_animation(movement): 
	if movement != Vector2.ZERO and !player_attacking and !player_knockbacked:
		animation_player.play("walk")
	elif movement == Vector2.ZERO and !player_attacking and !player_knockbacked:
		animation_player.play("idle")

func player_movement():
	input_movement = Input.get_vector("Left", "Right", "Up", "Down")
	if input_movement != Vector2.ZERO:
		$Sprite2D.flip_h = input_movement.x < 0
		velocity = input_movement * SPEED
	else:
		velocity = Vector2.ZERO 
	player_animation(input_movement)
	player_attack()
	move_and_slide()

func player_attack():
	if Input.is_action_just_pressed("basic_attack") and !player_attacking:
		player_attacking = true
		$Attacks.basic_attack($Sprite2D.flip_h, animation_player)
	elif Input.is_action_just_pressed("medium_attack") and !player_attacking:
		player_attacking = true
		$Attacks.medium_attack($Sprite2D.flip_h, animation_player)
	elif Input.is_action_just_pressed("heavy_attack") and !player_attacking:
		player_attacking = true
		$Attacks.heavy_attack($Sprite2D.flip_h, animation_player)
	

func take_damage(damage: int, enemy_velocity: Vector2):
	if player_knockbacked:
		return
	GameManager.player_health = GameManager.player_health - damage
	GameManager.player_health_changed.emit()
	if GameManager.player_health <= 0:
		player_alive = false
		animation_player.play("dead")
	else:
		knockback(enemy_velocity)

func knockback(enemy_velocity: Vector2):
	var knockback_direction = (global_position - enemy_velocity).normalized() * 1000
	velocity = knockback_direction
	player_knockbacked = true
	animation_player.play("receive_damage")
	move_and_slide()
	await get_tree().create_timer(0.5).timeout
	player_knockbacked = false
	state_reset()


func _on_health_reg_timer_timeout():
	if GameManager.player_health < 100:
		if GameManager.player_health + 8 <= 100:
			GameManager.player_health = 8 + GameManager.player_health
		else:
			GameManager.player_health = 100
		GameManager.player_health_changed.emit()
		print(GameManager.player_health)
