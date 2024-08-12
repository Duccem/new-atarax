extends PlayerAttack

@onready var arrow = preload("res://scenes/arrow.tscn")

func _ready() -> void:
	$basic_attack/CollisionShape2D.disabled = true
	$medium_attack/CollisionShape2D.disabled = true

func _physics_process(_delta):
	$heavy_attack.look_at(get_global_mouse_position())

func basic_attack(flipped: bool, _animator: AnimationPlayer) -> void:
	$basic_attack/CollisionShape2D.position.x += -10 if flipped else 10
	_animator.play("basic_attack")

func medium_attack(flipped: bool, _animator: AnimationPlayer) -> void:
	$medium_attack/CollisionShape2D.position.x += -10 if flipped else 10
	_animator.play("medium_attack")

func heavy_attack(_flipped: bool, animator: AnimationPlayer):
	animator.play("heavy_attack")
	await get_tree().create_timer(0.9).timeout
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position = global_position
	arrow_instance.rotation = $heavy_attack.rotation
	get_tree().root.add_child(arrow_instance)

func reset_state() -> void:
	$basic_attack/CollisionShape2D.position.x = 0
	$medium_attack/CollisionShape2D.position.x = 0

func _on_basic_attack_body_entered(body):
	if body.name == "enemy":
		body.take_damage(10)

func _on_medium_attack_body_entered(body):
	if body.name == "enemy":
		body.take_damage(20)