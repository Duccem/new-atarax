extends TextureProgressBar


func _ready():
	GameManager.player_health_changed.connect(update)
	update()

func update():
	value = GameManager.player_health * 100.0 / 100.0
