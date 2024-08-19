extends Node2D
class_name Weapon

@onready var animation_player = $animations
@onready var hitbox = $icon/hitbox

@export var item_resource: InventoryItem


func _physics_process(_delta):
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	move(mouse_direction)

func _input(event):
	if event.is_action_pressed("basic_attack"):
			animation_player.play("move_1")

func move(mouse_direction: Vector2) -> void:
	#if not animation_player.is_playing():
	rotation = mouse_direction.angle()
	hitbox.knockback_direction = mouse_direction
	if scale.y == 1 and mouse_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_direction.x > 0:
		scale.y = 1


func reset_state():
	animation_player.play("RESET")
