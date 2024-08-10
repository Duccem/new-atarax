extends CharacterBody2D


const SPEED = 100

var health = 100
var player_is_alive = true

var input_movement = Vector2.ZERO
@onready var animation_tree = $animation_tree
@onready var anim_state = animation_tree.get("parameters/playback")

var player_attacking = false

func _ready():
	$Sword/CollisionShape2D.disabled = true

func _physics_process(_delta):
	player_movement()

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


func player():
	pass
	
