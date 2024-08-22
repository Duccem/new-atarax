extends CanvasLayer

@onready var inventory = $Control/HBoxContainer/Inventory
@onready var equipment = $Control/HBoxContainer/Equipment


func _ready():
	equipment.toggled.connect(toogle_game)
	inventory.toggled.connect(toogle_game)

func _input(event):
	if event.is_action_pressed("inventory_toggle"):
		inventory.toggle_inventory()
	if event.is_action_pressed("equipment_toggle"):
		equipment.toggle()


func toogle_game(close_or_open: bool):
	if close_or_open:
		pause_game()
	else:
		resume_game()

func pause_game():
	if !GameManager.game_paused:
		GameManager.pause_game()

func resume_game():
	if inventory.is_open or equipment.is_open:
		return
	GameManager.resume_game()
