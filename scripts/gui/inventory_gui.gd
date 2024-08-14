extends Control

var is_open = false

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _ready():
	visible = is_open
	inventory.updated.connect(update)
	update()

func toggle_inventory():
	is_open = !is_open
	visible = is_open
	if is_open:
		GameManager.pause_game()
	else:
		GameManager.resume_game()



