extends Control

var is_open = false

func _ready():
	visible = is_open

func toggle_inventory():
	is_open = !is_open
	visible = is_open
	if is_open:
		GameManager.pause_game()
	else:
		GameManager.resume_game()



