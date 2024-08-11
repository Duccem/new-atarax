extends CharacterBody2D


const SPEED = 100

var input_movement = Vector2.ZERO
@onready var animation_tree = $animation_tree
@onready var anim_state = animation_tree.get("parameters/playback")

var player_attacking = false
var player_alive = true

func _ready():
	$Sword/CollisionShape2D.disabled = true

func _physics_process(_delta):
	if player_alive:
		player_movement()
	else:
		GameManager.reset_game()

func player_animation(movement): 
	if movement != Vector2.ZERO and !player_attacking:
		anim_state.travel("Walk")
	elif movement == Vector2.ZERO and !player_attacking:
		anim_state.travel("Idle")
	elif player_attacking:
		anim_state.travel("Attack")

func player_movement():
	input_movement = Input.get_vector("Left", "Right", "Up", "Down")
	if input_movement != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_movement)
		animation_tree.set("parameters/Walk/blend_position", input_movement)
		animation_tree.set("parameters/Attack/blend_position", input_movement)
		velocity = input_movement * SPEED
	else:
		velocity = Vector2.ZERO 
	player_attack()
	player_animation(input_movement)
	move_and_slide()

func player_attack():
	if Input.is_action_just_pressed("Attack") and !player_attacking:
		player_attacking = true

func state_reset():
	player_attacking = false

func take_damage(damage: int, enemy_velocity: Vector2):
	GameManager.player_health = GameManager.player_health - damage
	GameManager.player_health_changed.emit()
	if GameManager.player_health <= 0:
		player_alive = false
		anim_state.travel("Dead")
	else:
		knockback(enemy_velocity)

func knockback(enemy_velocity: Vector2):
	print("knockback")
	print(enemy_velocity)
	var knockback_direction = (global_position - enemy_velocity).normalized() * 1000
	velocity = knockback_direction
	move_and_slide()

func _on_sword_body_entered(body):
	if body.name == "enemy":
		body.take_damage(10)


func _on_health_reg_timer_timeout():
	if GameManager.player_health < 100:
		if GameManager.player_health + 8 <= 100:
			GameManager.player_health = 8 + GameManager.player_health
		else:
			GameManager.player_health = 100
		GameManager.player_health_changed.emit()
		print(GameManager.player_health)
