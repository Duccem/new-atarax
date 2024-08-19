extends Area2D
class_name WeaponHitbox
@onready var collision_shape: CollisionShape2D = get_child(0)
@onready var timer: Timer = Timer.new()
@export var damage: int = 1
@export var knockback_force: int = 300
var body_inside: bool = false
var knockback_direction: Vector2 = Vector2.ZERO


func _on_body_entered(body:Node2D):
	if body.name == "enemy":
		body.take_damage(10, knockback_direction)
