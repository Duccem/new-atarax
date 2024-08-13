extends CharacterBody2D

var SPEED = 20
var player_chase = false
var player = null

var health = 50
var knockbacked = false


@onready var drop = preload("res://scenes/drop.tscn")
@onready var nav_agent = $Navigation/NavigationAgent2D

func _ready():
	$HealthBar.value = health
	$HealthBar.max_value = health
	$HealthBar.visible = false
	nav_agent.target_position = self.global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(_delta):
	if health <= 0 or knockbacked:
		return;
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED 
		$AnimatedSprite2D.flip_h = player.position.x < position.x
		var animation_name = "move_" + set_animation_direction()
		$AnimatedSprite2D.play(animation_name)
		move_and_slide()
	else: 
		$AnimatedSprite2D.play("idle_front")


func _on_detection_area_body_entered(body:Node2D):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body:Node2D):
	player = null
	player_chase = false


func take_damage(damage: int):
	health -= damage
	update_health_bar()
	if health <= 0:
		$AnimatedSprite2D.play("dead")
		$HealthBar.visible = false
		await  get_tree().create_timer(1.5).timeout
		drop_loot()
		queue_free()
	else :
		knockback(player.global_position)

func set_animation_direction():
	if player.position.y + 5 < position.y:
		return "back"
	elif player.position.y > position.y:
		return "front"
	else:
		return "side"

func knockback(player_position: Vector2):
	var knockback_direction = (global_position - player_position).normalized() * 1000
	velocity = knockback_direction
	$AnimatedSprite2D.flip_h = player.position.x < position.x
	var animation_name = "hurt_" + set_animation_direction()
	$AnimatedSprite2D.play(animation_name)
	knockbacked = true
	move_and_slide()
	await get_tree().create_timer(0.5).timeout
	knockbacked = false

func drop_loot():
	var loot = drop.instantiate()
	loot.global_position = global_position
	get_tree().root.add_child(loot)

func update_health_bar():
	$HealthBar.value = health

	if health >= 100:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true

func _on_hitbox_body_entered(body:Node2D):
	if body.name == "player":
		body.take_damage(10, global_position)

func _on_path_calculate_time_timeout():
	if player:
		nav_agent.target_position = player.position
	else:
		nav_agent.target_position = global_position
