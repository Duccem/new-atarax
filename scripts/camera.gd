extends Camera2D


@export var player: CharacterBody2D
@export var map: TileMap


func _ready():
	var map_rect = map.get_used_rect()
	map_rect.position = map_rect.position * map.rendering_quadrant_size
	var tile_size = map.rendering_quadrant_size
	var world_size = map_rect.size * tile_size

	limit_left = 0
	limit_top = 0
	limit_right = world_size.x
	limit_bottom = world_size.y

func _physics_process(_delta):
	position = player.position
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position, 0.14)
